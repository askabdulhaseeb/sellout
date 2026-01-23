import 'package:flutter/material.dart';
import '../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../postage/domain/entities/service_point_entity.dart';
import '../../../../../../../../../postage/data/models/service_points_response_model.dart';
import '../../../../../../../../../../core/dialogs/service_point_selection/service_point_selection.dart';

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
    required CartItemServicePointsEntity servicePointsData,
    required String cartItemId,
    String? productName,
  }) async {
    // Convert entities to models
    final List<ServicePointModel> servicePoints = servicePointsData
        .servicePoints
        .map((ServicePointEntity e) => ServicePointModel.fromEntity(e))
        .toList();

    // Show the reusable dialog
    final ServicePointModel? result = await ServicePointSelectionDialog.show(
      context: context,
      servicePoints: servicePoints,
      productName: productName,
      onRadiusChanged: (String radius) {
        // TODO: Implement radius change logic - fetch new locations with this radius
        AppLog.info('Radius changed to: $radius', name: 'ServicePointsDialog');
      },
      onCategoryChanged: (String category) {
        // TODO: Implement category filter logic
        AppLog.info(
          'Category changed to: $category',
          name: 'ServicePointsDialog',
        );
      },
    );

    // Convert back to entity if result exists
    if (result != null) {
      return servicePointsData.servicePoints.firstWhere(
        (ServicePointEntity e) => e.id == result.id,
      );
    }
    return null;
  }
}
