import 'package:flutter/material.dart';
import '../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../postage/domain/entities/service_point_entity.dart';
import '../../../../../../../../../postage/data/models/service_points_response_model.dart';
import '../../../../../../../../../postage/domain/usecase/get_service_points_usecase.dart';
import '../../../../../../../../../postage/domain/params/get_service_points_param.dart';
import '../../../../../../../../../../core/dialogs/service_point_selection/service_point_selection.dart';
import '../../../../../../../../../../core/dialogs/service_point_selection/enums/service_point_enums.dart';
import '../../../../../../../../../../core/sources/data_state.dart';

/// Convenience method for showing service point selection dialog
/// specifically for basket/checkout feature.
///
/// This is just a helper that converts your domain entities to models
/// and back. The actual dialog is the reusable ServicePointSelectionDialog.
class ServicePointsDialog {
  ServicePointsDialog._();

  /// Show the service points selection dialog
  static Future<ServicePointEntity?> show({
    required BuildContext context,
    required List<String> cartItemIds,
    required String postalCode ,
  }) async {
    final ServicePointModel? selection = await showDialog<ServicePointModel?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return _ServicePointsDialogHost(
          cartItemIds: cartItemIds,
          postalCode: postalCode,
        );
      },
    );

    return selection;
  }
}

class _ServicePointsDialogHost extends StatefulWidget {
  const _ServicePointsDialogHost({
    required this.cartItemIds,
    required this.postalCode,
  });

  final List<String> cartItemIds;
  final String postalCode;

  @override
  State<_ServicePointsDialogHost> createState() =>
      _ServicePointsDialogHostState();
}

class _ServicePointsDialogHostState extends State<_ServicePointsDialogHost> {
  List<ServicePointModel> _servicePoints = <ServicePointModel>[];
  bool _isLoading = true;
  String _carrier = '';

  @override
  void initState() {
    super.initState();
    _fetchServicePoints(SearchRadius.km2); // Default radius
  }

  Future<void> _fetchServicePoints(SearchRadius radius) async {
    final int radiusMeters = radius.meters;
    AppLog.info(
      'Fetching service points with radius $radiusMeters m',
      name: 'ServicePointsDialog._fetchServicePoints',
    );

    setState(() => _isLoading = true);

    final GetServicePointsParam param = GetServicePointsParam(
      cartItemIds: widget.cartItemIds,
      postalCode: widget.postalCode,
      carrier: _carrier,
      radius: radiusMeters,
    );

    final DataState<ServicePointsResponseEntity> result = await 
        GetServicePointsUsecase(locator()).call(param);

    if (result is DataSuccess<ServicePointsResponseEntity>) {
      // Get service points from the first cart item
      final String firstCartItemId = widget.cartItemIds.first;
      final CartItemServicePointsEntity? data =
          result.entity?.results[firstCartItemId];

      if (data != null) {
        setState(() {
          _servicePoints = data.servicePoints
              .map((ServicePointEntity e) => ServicePointModel.fromEntity(e))
              .toList();
          _isLoading = false;
        });
        return;
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ServicePointSelectionDialog(
      servicePoints: _servicePoints,
      onRadiusChanged: _fetchServicePoints,
      onCategoryChanged: (ServicePointCategory category) {
        AppLog.info(
          'Category changed to: ${category.key}',
          name: 'ServicePointsDialog._handleCategoryChanged',
        );
      },
      isLoading: _isLoading,
    );
  }
}
