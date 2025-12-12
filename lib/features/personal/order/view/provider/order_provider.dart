import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../services/get_it.dart';
import '../../../../postage/domain/params/add_label_params.dart';
import '../../../../postage/domain/usecase/buy_label_usecase.dart';
import '../../data/source/local/local_orders.dart';
import '../../domain/entities/order_entity.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../domain/usecase/update_order_usecase.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider(this._updateOrderUsecase) {
    _orderBoxStream = LocalOrders().watch().listen(_onBoxEvent);
  }
  final UpdateOrderUsecase _updateOrderUsecase;
  OrderEntity? _sellerOrder;
  StreamSubscription? _orderBoxStream;
  String? _currentOrderId;

  OrderEntity? get order => _sellerOrder;

  void _onBoxEvent(event) {
    if (_currentOrderId != null && event.key == _currentOrderId) {
      // Order changed in box, reload and notify
      final OrderEntity? updated = LocalOrders().get(_currentOrderId!);
      if (updated != null) {
        _sellerOrder = updated;
        notifyListeners();
      }
    }
  }

  void loadOrder(String orderId) {
    _currentOrderId = orderId;
    _sellerOrder = LocalOrders().get(orderId);
    notifyListeners();
  }

  void refreshOrder(String orderId) {
    _sellerOrder = LocalOrders().get(orderId);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Separate loading state for buying label action
  bool _isBuyingLabel = false;
  bool get isBuyingLabel => _isBuyingLabel;
  void _setBuyingLabel(bool value) {
    _isBuyingLabel = value;
    notifyListeners();
  }

  // Separate loading state for downloading label action
  bool _isDownloadingLabel = false;
  bool get isDownloadingLabel => _isDownloadingLabel;
  void _setDownloadingLabel(bool value) {
    _isDownloadingLabel = value;
    notifyListeners();
  }

  Future<void> updateSellerOrder(String orderId, StatusType status) async {
    setLoading(true);
    final UpdateOrderParams params = UpdateOrderParams(
      orderId: orderId,
      status: status,
    );
    final DataState<bool> result = await _updateOrderUsecase(params);
    if (result is DataSuccess) {
      AppLog.info('order_updated_successfully'.tr());
      loadOrder(orderId);
      setLoading(false);
    } else {
      AppLog.error(
        result.exception!.message,
        name: 'ProfileProvider.updateOrder - else',
      );
      setLoading(false);
    }
  }

  Future<void> buyLabel(String orderId) async {
    _setBuyingLabel(true);
    try {
      final DataState res = await BuyLabelUsecase(
        locator(),
      ).call(BuyLabelParams(orderId: orderId));
      if (res is DataSuccess) {
        // remote call should have updated LocalOrders; refresh local order
        refreshOrder(orderId);
        AppLog.info('buy_label_success'.tr());
      } else {
        AppLog.error(
          res.exception?.message ?? 'buy_label_failed'.tr(),
          name: 'OrderProvider.buyLabel - Else',
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderProvider.buyLabel - Catch',
        error: e,
        stackTrace: stc,
      );
    } finally {
      _setBuyingLabel(false);
    }
  }

  Future<void> downloadLabel(String? url) async {
    _setDownloadingLabel(true);
    try {
      final String? labelUrl = url;
      if (labelUrl != null && labelUrl.isNotEmpty) {
        final Uri uri = Uri.parse(labelUrl);

        // Download the file
        final http.Response response = await http.get(uri);
        if (response.statusCode == 200) {
          final String fileName = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.last
              : 'label_${DateTime.now().millisecondsSinceEpoch}.pdf';

          File file;

          if (Platform.isAndroid) {
            // Request storage permission on Android
            PermissionStatus status = await Permission.storage.request();
            if (!status.isGranted) {
              // Try manage external storage for Android 11+
              try {
                status = await Permission.manageExternalStorage.request();
              } catch (_) {}
            }

            if (!status.isGranted) {
              AppLog.error(
                'Storage permission denied',
                name: 'OrderProvider.downloadLabel',
              );
              return;
            }

            // Attempt to save to public Downloads folder
            final String downloadsPath = '/storage/emulated/0/Download';
            final String filePath = '$downloadsPath/$fileName';
            file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
          } else {
            // Fallback for iOS and other platforms: app documents
            final Directory dir = await getApplicationDocumentsDirectory();
            final String filePath = '${dir.path}/$fileName';
            file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
          }

          AppLog.info('download_label_success'.tr());

          // Open the downloaded file
          await OpenFile.open(file.path);
        } else {
          AppLog.error(
            'Failed to download label: ${response.statusCode}',
            name: 'OrderProvider.downloadLabel',
          );
        }
      } else {
        AppLog.error(
          'No label URL available',
          name: 'OrderProvider.downloadLabel',
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderProvider.downloadLabel - Catch',
        error: e,
        stackTrace: stc,
      );
    } finally {
      _setDownloadingLabel(false);
    }
  }

  @override
  void dispose() {
    _orderBoxStream?.cancel();
    super.dispose();
  }
}
