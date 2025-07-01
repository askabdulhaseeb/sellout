import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../../features/attachment/domain/entities/picked_attachment.dart';
import '../enums/core/api_request_type.dart';
import '../functions/app_log.dart';
import 'data_state.dart';
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import 'local/local_request_history.dart';
export 'dart:convert';
export '../enums/core/api_request_type.dart';
export 'data_state.dart';
import 'package:http_parser/http_parser.dart';

class ApiCall<T> {
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
      final http.Request request =
          http.Request(requestType.json, Uri.parse(url));

      /// Request Fields
      if (fieldsMap != null && fieldsMap.isNotEmpty) {
        request.bodyFields = fieldsMap;
      }

      if (attachments != null && attachments.isNotEmpty) {
        request.bodyFields.addEntries(attachments.map((PickedAttachment e) {
          return MapEntry<String, String>('files', e.file.path);
        }));
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
        final String tokenStr =
            token.startsWith('Bearer') ? token : 'Bearer $token';
        headers.addAll(<String, String>{'Authorization': tokenStr});
      }
      request.headers.addAll(headers);
      // debugPrint('👉🏻 API Call: header - $headers');

      /// Request Body
      if (body != null && body.isNotEmpty) {
        request.body = body;
      }

      // debugPrint('👉🏻 API Call: body - $body');

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
          await LocalRequestHistory().save(apiRequestEntity);
          return DataSuccess<T>(data, null);
        }
      } else {
        // Unauthorized
        // Failer
        final String data = await response.stream.bytesToString();
        final Map<String, dynamic> decoded = jsonDecode(data);

        AppLog.error(
          '${response.statusCode} - API: message -> ${decoded['message']} - detail -> ${decoded['details']}',
          name: 'ApiCall.call - else',
          error: CustomException('ERROR: ${decoded['error']}'),
        );
        return DataFailer<T>(CustomException('ERROR: ${decoded['message']}',
            reason: decoded['error']));
      }
    } catch (e) {
      AppLog.error(
        'Catch - call - API: $e',
        name: 'ApiCall.call - Catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<T>(CustomException(e.toString()));
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
      http.MultipartRequest request =
          http.MultipartRequest(requestType.json, Uri.parse(url));

      if (fieldsMap != null && fieldsMap.isNotEmpty) {
        request.fields.addAll(fieldsMap);
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
          final http.MultipartFile multipartFile =
              await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: mediaType,
          );
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
        final String tokenStr =
            token.startsWith('Bearer') ? token : 'Bearer $token';
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
          await LocalRequestHistory().save(apiRequestEntity);
          return DataSuccess<T>(data, null);
        }
      } else {
        debugPrint('🔴 Status Code - ${response.statusCode}');
        // Unauthorized
        // Failer
        final String data = await response.stream.bytesToString();
        final Map<String, dynamic> decoded = jsonDecode(data);

        AppLog.error(
          'ApiCall.callFormData - else ERROR: ${response.statusCode} - API: message -> ${decoded['message']} -  detail -> ${decoded['details']}',
          name: 'ApiCall.callFormData - else',
          error: CustomException('ERROR: ${decoded['message']}'),
        );
        return DataFailer<T>(CustomException('ERROR: ${decoded['message']}'));
      }
    } catch (e) {
      debugPrint('🔴 ERROR: $fieldsMap');
      AppLog.error(
        'ApiCall.callFormData - Catch ERROR: ${e.toString()}',
        name: 'ApiCall.callFormData - Catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<T>(CustomException(e.toString()));
    }
  }
}
