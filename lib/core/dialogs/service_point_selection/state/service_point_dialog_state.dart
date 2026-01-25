import '../enums/service_point_enums.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';

/// State management for service point selection dialog
class ServicePointDialogState {
  ServicePointDialogState({
    required this.selectedRadius, required this.selectedCategory, required this.servicePoints, this.selectedPoint,
  });

  final ServicePointModel? selectedPoint;
  final SearchRadius selectedRadius;
  final ServicePointCategory selectedCategory;
  final List<ServicePointModel> servicePoints;

  ServicePointDialogState copyWith({
    ServicePointModel? selectedPoint,
    SearchRadius? selectedRadius,
    ServicePointCategory? selectedCategory,
    List<ServicePointModel>? servicePoints,
  }) {
    return ServicePointDialogState(
      selectedPoint: selectedPoint ?? this.selectedPoint,
      selectedRadius: selectedRadius ?? this.selectedRadius,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      servicePoints: servicePoints ?? this.servicePoints,
    );
  }

  /// Get filtered service points based on selected category
  List<ServicePointModel> get filteredServicePoints {
    if (selectedCategory == ServicePointCategory.all) {
      return servicePoints;
    }

    return servicePoints.where((ServicePointModel point) {
      final String type = point.type.toLowerCase();

      // Match category with point type
      switch (selectedCategory) {
        case ServicePointCategory.shops:
          return type.contains('shop');
        case ServicePointCategory.lockers:
          return type.contains('locker');
        case ServicePointCategory.post:
          return type.contains('post') || type.contains('office');
        case ServicePointCategory.all:
          return true;
      }
    }).toList();
  }
}
