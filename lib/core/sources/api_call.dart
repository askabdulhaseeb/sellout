import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../../features/attachment/domain/entities/picked_attachment.dart';
import '../enums/core/api_request_type.dart';
import '../extension/string_ext.dart';
import '../functions/app_log.dart';
import 'data_state.dart';
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import 'local/local_request_history.dart';
export 'dart:convert';
export '../enums/core/api_request_type.dart';
export 'data_state.dart';
import 'package:http_parser/http_parser.dart';

class ApiCall<T> {
  /// Validates and sanitizes a JSON body string before sending to API.
  /// Returns null if validation fails, otherwise returns sanitized JSON.
  static String? _validateAndSanitizeBody(String? body) {
    if (body == null) return null;

    final String trimmed = body.trim();
    if (trimmed.isEmpty) return null;

    // Validate JSON structure
    try {
      final dynamic decoded = jsonDecode(trimmed);
      if (decoded == null) return null;

      // Re-encode to ensure proper escaping and sanitization
      final String sanitized = jsonEncode(_sanitizeValue(decoded));
      return sanitized;
    } catch (e) {
      AppLog.error(
        'Invalid JSON body provided',
        name: 'ApiCall._validateAndSanitizeBody',
        error: e,
      );
      return null;
    }
  }

  /// Recursively sanitizes values in JSON structures.
  static dynamic _sanitizeValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return _sanitizeString(value);
    } else if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic val) => MapEntry<String, dynamic>(
          _sanitizeString(key.toString()),
          _sanitizeValue(val),
        ),
      );
    } else if (value is List) {
      return value.map(_sanitizeValue).toList();
    } else if (value is num || value is bool) {
      return value;
    }

    // Convert unexpected types to string representation
    return _sanitizeString(value.toString());
  }

  /// Sanitizes a string value by escaping dangerous characters.
  static String _sanitizeString(String value) {
    // Remove null bytes and other control characters (except newline, tab)
    String sanitized = value.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '');

    // Trim excessive whitespace
    sanitized = sanitized.trim();

    return sanitized;
  }

  /// Validates and sanitizes field map values.
  static Map<String, String>? _validateAndSanitizeFields(
    Map<String, String>? fields,
  ) {
    if (fields == null || fields.isEmpty) return null;

    final Map<String, String> sanitized = <String, String>{};
    for (final MapEntry<String, String> entry in fields.entries) {
      final String key = _sanitizeString(entry.key);
      final String value = _sanitizeString(entry.value);

      // Skip entries with empty keys
      if (key.isEmpty) continue;

      sanitized[key] = value;
    }

    return sanitized.isEmpty ? null : sanitized;
  }

  /// Extracts endpoint path from full URL for safe logging.
  static String _extractEndpointForLogging(String url) {
    try {
      final Uri uri = Uri.parse(url);
      return uri.path;
    } catch (_) {
      return '/unknown';
    }
  }

  /// Returns a user-friendly error message without exposing sensitive details.
  static String _getSafeErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Authentication required';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Validation failed';
      case 429:
        return 'Too many requests';
      case 500:
      case 502:
      case 503:
        return 'Server error';
      default:
        return 'Request failed';
    }
  }

  Future<DataState<T>> call({
    required String endpoint,
    required ApiRequestType requestType,
    String? baseURL,
    String? body,
    Map<String, String>? fieldsMap,
    List<PickedAttachment>? attachments,
    Map<String, String>? extraHeader,
    bool isConnectType = true,
    bool isAuth = true,
    int count = 1,
  }) async {
    try {
      String url = baseURL ?? dotenv.env['baseURL'] ?? '';
      if (url.isEmpty) {
        return DataFailer<T>(CustomException('Base URL is Empty'));
      }
      url = '$url${endpoint.startsWith('/') ? endpoint : '/$endpoint'}';
      // if (!url.endsWith('/')) url += '/';

      /// Request
      final http.Request request = http.Request(
        requestType.json,
        Uri.parse(url),
      );

      /// Request Fields (sanitized)
      final Map<String, String>? sanitizedFields =
          _validateAndSanitizeFields(fieldsMap);
      if (sanitizedFields != null && sanitizedFields.isNotEmpty) {
        request.bodyFields = sanitizedFields;
      }

      if (attachments != null && attachments.isNotEmpty) {
        request.bodyFields.addEntries(
          attachments.map((PickedAttachment e) {
            return MapEntry<String, String>('files', e.file.path);
          }),
        );
      }

      /// Request Header
      // [Content-Type]
      final Map<String, String> headers = extraHeader ?? <String, String>{};
      if (isConnectType) {
        headers.addAll(<String, String>{'Content-Type': 'application/json'});
      }
      // [Authorization]
      if (isAuth) {
        final String? token = LocalAuth.token;
        if (token == null) {
          return DataFailer<T>(CustomException('Unauthorized Access'));
        }
        final String tokenStr = token.startsWith('Bearer')
            ? token
            : 'Bearer $token';
        headers.addAll(<String, String>{'Authorization': tokenStr});
      }
      request.headers.addAll(headers);
      // debugPrint('👉🏻 API Call: header - $headers');

      /// Request Body (validated and sanitized)
      final String? sanitizedBody = _validateAndSanitizeBody(body);
      if (sanitizedBody != null && sanitizedBody.isNotEmpty) {
        request.body = sanitizedBody;
      } else if (body != null && body.isNotEmpty) {
        // Body was provided but failed validation
        AppLog.error(
          'Request body failed validation - rejecting request',
          name: 'ApiCall.call - body validation',
          error: CustomException('Invalid request body format'),
        );
        return DataFailer<T>(CustomException('Invalid request body format'));
      }

      // debugPrint('👉🏻 API Call: body - $sanitizedBody');

      /// Send Request
      http.StreamedResponse response = await request.send();
      if (!url.contains('/user/') && !url.contains('/post/')) {
        debugPrint('👉🏻 API Call: url - $url');
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String data = await response.stream.bytesToString();
        if (data.isEmpty) {
          AppLog.error(
            'No Data Found - API: $url',
            name: 'ApiCall.call - if - data.isEmpty',
            error: CustomException('ERROR: No Data Found'),
          );
          return DataFailer<T>(CustomException('ERROR: No Data Found'));
        } else {
          ApiRequestEntity apiRequestEntity = ApiRequestEntity(
            url: url,
            encodedData: data,
          );
          await LocalRequestHistory().save(
            url.toSHA256(),
            apiRequestEntity,
          );
          return DataSuccess<T>(data, null);
        }
      } else {
        // Request failed - log safely without sensitive data
        final String safeEndpoint = _extractEndpointForLogging(url);
        final String safeMessage = _getSafeErrorMessage(response.statusCode);

        AppLog.error(
          'Request failed: $safeEndpoint (${response.statusCode})',
          name: 'ApiCall.call',
        );

        // Parse response for user-facing message only
        String userMessage = safeMessage;
        try {
          final String data = await response.stream.bytesToString();
          final Map<String, dynamic> decoded = jsonDecode(data);
          // Only use 'message' field if it exists and is non-empty
          final String? apiMessage = decoded['message']?.toString();
          if (apiMessage != null && apiMessage.isNotEmpty) {
            userMessage = apiMessage;
          }
        } catch (_) {
          // Ignore JSON parsing errors, use safe message
        }

        return DataFailer<T>(CustomException(userMessage));
      }
    } catch (e) {
      // Log generic error without exposing internal details
      AppLog.error(
        'Request failed: $endpoint',
        name: 'ApiCall.call',
      );
      return DataFailer<T>(CustomException('Request failed'));
    }
  }

  Future<DataState<T>> callFormData({
    required String endpoint,
    required ApiRequestType requestType,
    String? fileKey,
    Map<String, PickedAttachment>? fileMap,
    String? baseURL,
    Map<String, String>? fieldsMap,
    List<PickedAttachment>? attachments,
    Map<String, String>? extraHeader,
    bool isConnectType = true,
    bool isAuth = true,
    int count = 1,
  }) async {
    try {
      String url = baseURL ?? dotenv.env['baseURL'] ?? '';
      if (url.isEmpty) {
        return DataFailer<T>(CustomException('Base URL is Empty'));
      }
      url = '$url${endpoint.startsWith('/') ? endpoint : '/$endpoint'}';

      /// Request
      http.MultipartRequest request = http.MultipartRequest(
        requestType.json,
        Uri.parse(url),
      );

      /// Sanitize and add fields
      final Map<String, String>? sanitizedFields =
          _validateAndSanitizeFields(fieldsMap);
      if (sanitizedFields != null && sanitizedFields.isNotEmpty) {
        request.fields.addAll(sanitizedFields);
      }

      if (attachments != null && attachments.isNotEmpty) {
        for (PickedAttachment element in attachments) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fileKey ?? 'files',
              element.file.path,
            ),
          );
        }
      }

      if (fileMap != null && fileMap.isNotEmpty) {
        for (final MapEntry<String, PickedAttachment> entry
            in fileMap.entries) {
          final String key = entry.key;
          final File file = entry.value.file;
          final String mimeType =
              lookupMimeType(file.path) ?? 'application/octet-stream';
          final MediaType mediaType = MediaType.parse(mimeType);
          final http.MultipartFile multipartFile = await http
              .MultipartFile.fromPath(key, file.path, contentType: mediaType);
          request.files.add(multipartFile);
        }
      }

      /// Request Header
      // [Content-Type]
      final Map<String, String> headers = extraHeader ?? <String, String>{};
      if (isConnectType) {
        headers.addAll(<String, String>{'Content-Type': 'application/json'});
      }
      // [Authorization]
      if (isAuth) {
        final String? token = LocalAuth.token;
        if (token == null) {
          return DataFailer<T>(CustomException('Unauthorized Access'));
        }
        final String tokenStr = token.startsWith('Bearer')
            ? token
            : 'Bearer $token';
        headers.addAll(<String, String>{'Authorization': tokenStr});
      }

      request.headers.addAll(headers);
      // debugPrint('👉🏻 API Call: header - $headers');

      /// Send Request
      http.StreamedResponse response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('👉🏻 API Call: url - $url');
        final String data = await response.stream.bytesToString();
        debugPrint('✅ Request Success');
        if (data.isEmpty) {
          AppLog.error(
            'No Data Found - API: $url',
            name: 'ApiCall.callFormData - if - data.isEmpty',
            error: CustomException('ERROR: No Data Found'),
          );
          return DataFailer<T>(CustomException('ERROR: No Data Found'));
        } else {
          ApiRequestEntity apiRequestEntity = ApiRequestEntity(
            url: url,
            encodedData: data,
          );
          await LocalRequestHistory().save(
            url.toSHA256(),
            apiRequestEntity,
          );
          return DataSuccess<T>(data, null);
        }
      } else {
        // Request failed - log safely without sensitive data
        final String safeEndpoint = _extractEndpointForLogging(url);
        final String safeMessage = _getSafeErrorMessage(response.statusCode);

        AppLog.error(
          'Request failed: $safeEndpoint (${response.statusCode})',
          name: 'ApiCall.callFormData',
        );

        // Parse response for user-facing message only
        String userMessage = safeMessage;
        try {
          final String data = await response.stream.bytesToString();
          final Map<String, dynamic> decoded = jsonDecode(data);
          // Only use 'message' field if it exists and is non-empty
          final String? apiMessage = decoded['message']?.toString();
          if (apiMessage != null && apiMessage.isNotEmpty) {
            userMessage = apiMessage;
          }
        } catch (_) {
          // Ignore JSON parsing errors, use safe message
        }

        return DataFailer<T>(CustomException(userMessage));
      }
    } catch (e) {
      // Log generic error without exposing internal details
      AppLog.error(
        'Request failed: $endpoint',
        name: 'ApiCall.callFormData',
      );
      return DataFailer<T>(CustomException('Request failed'));
    }
  }
}

//   CSRF Protected Routes - Frontend Implementation Guide

//   Required Header for ALL Protected Routes:

//   Header Name: X-Requested-WithHeader Value: XMLHttpRequest

//   ---
//   Complete List of CSRF-Protected Endpoints

//   :closed_lock_with_key: User Authentication & Management (10 routes)

//   | Method | Endpoint                      | Description                | Required Headers                 |
//   |--------|-------------------------------|----------------------------|----------------------------------|
//   | POST   | /api/user/profilePic          | Upload profile picture     | Authorization + X-Requested-With |
//   | POST   | /api/user/logout              | Logout from current device | Authorization + X-Requested-With |
//   | POST   | /api/user/logout/all          | Logout from all devices    | Authorization + X-Requested-With |
//   | POST   | /api/user/deactivate          | Deactivate account         | Authorization + X-Requested-With |
//   | PATCH  | /api/user/switchAccount       | Switch account type        | Authorization + X-Requested-With |
//   | PATCH  | /api/user/add/address         | Add new address            | Authorization + X-Requested-With |
//   | PATCH  | /api/user/update/address      | Update existing address    | Authorization + X-Requested-With |
//   | PATCH  | /api/user/update/:uid         | Update user profile        | Authorization + X-Requested-With |
//   | DELETE | /api/user/delete/:uid         | Delete user account        | Authorization + X-Requested-With |
//   | POST   | /api/userAuth/change/password | Change password            | Authorization + X-Requested-With |

//   ---
//   :office: Business Management (9 routes)

//   | Method | Endpoint                          | Description                     | Required Headers                 |
//   |--------|-----------------------------------|---------------------------------|----------------------------------|
//   | PATCH  | /api/business/update/member       | Update employee details         | Authorization + X-Requested-With |
//   | PATCH  | /api/business/reset/password      | Reset password                  | Authorization + X-Requested-With |
//   | PATCH  | /api/business/change/password     | Change password                 | Authorization + X-Requested-With |
//   | PATCH  | /api/business/add/member          | Add member to business          | Authorization + X-Requested-With |
//   | PATCH  | /api/business/update/invite       | Handle business invites         | Authorization + X-Requested-With |
//   | PATCH  | /api/business/profilePic          | Update business profile picture | Authorization + X-Requested-With |
//   | PATCH  | /api/business/update              | Update business profile         | Authorization + X-Requested-With |
//   | DELETE | /api/business/delete/:business_id | Delete business                 | Authorization + X-Requested-With |

//   ---
//   :package: Posts/Products (3 routes)

//   | Method | Endpoint                  | Description             | Required Headers                 |
//   |--------|---------------------------|-------------------------|----------------------------------|
//   | POST   | /api/post/create          | Create new post/product | Authorization + X-Requested-With |
//   | PATCH  | /api/post/update/:post_id | Update post/product     | Authorization + X-Requested-With |
//   | DELETE | /api/post/delete/:post_id | Delete post/product     | Authorization + X-Requested-With |

//   ---
//   :hammer_and_wrench: Services (7 routes)

//   | Method | Endpoint                        | Description                   | Required Headers                 |
//   |--------|---------------------------------|-------------------------------|----------------------------------|
//   | POST   | /api/service/create             | Create new service            | Authorization + X-Requested-With |
//   | PATCH  | /api/service/update/:service_id | Update service                | Authorization + X-Requested-With |
//   | PATCH  | /api/service/assign/employee    | Assign employees to service   | Authorization + X-Requested-With |
//   | PATCH  | /api/service/assign/services    | Assign services to employee   | Authorization + X-Requested-With |
//   | PATCH  | /api/service/remove/employees   | Remove employees from service | Authorization + X-Requested-With |
//   | PATCH  | /api/service/remove/services    | Remove services from employee | Authorization + X-Requested-With |
//   | DELETE | /api/service/delete/:service_id | Delete service                | Authorization + X-Requested-With |

//   ---
//   :moneybag: Offers (3 routes)

//   | Method | Endpoint                    | Description      | Required Headers                 |
//   |--------|-----------------------------|------------------|----------------------------------|
//   | POST   | /api/offer/create           | Create new offer | Authorization + X-Requested-With |
//   | PATCH  | /api/offer/update/:offer_id | Update offer     | Authorization + X-Requested-With |
//   | DELETE | /api/offer/delete/:offer_id | Delete offer     | Authorization + X-Requested-With |

//   ---
//   :package: Orders (4 routes)

//   | Method | Endpoint                 | Description           | Required Headers                 |
//   |--------|--------------------------|-----------------------|----------------------------------|
//   | POST   | /api/order/create        | Create new order      | Authorization + X-Requested-With |
//   | POST   | /api/order/buy/label     | Buy shipping label    | Authorization + X-Requested-With |
//   | POST   | /api/order/shipping/add  | Add shipping to order | Authorization + X-Requested-With |
//   | PATCH  | /api/order/update/status | Update order status   | Authorization + X-Requested-With |

//   ---
//   :credit_card: Payments (3 routes)

//   | Method | Endpoint               | Description                | Required Headers                 |
//   |--------|------------------------|----------------------------|----------------------------------|
//   | POST   | /api/payments/release  | Release payment            | Authorization + X-Requested-With |
//   | POST   | /api/payments/transfer | Transfer to Stripe Connect | Authorization + X-Requested-With |
//   | POST   | /api/payments/payout   | Payout to bank             | Authorization + X-Requested-With |