import 'package:flutter/material.dart';
import '../../../features/postage/data/models/service_points_response_model.dart';
import 'enums/service_point_enums.dart';
import 'state/service_point_dialog_state.dart';
import 'widgets/dialog_footer.dart';
import 'widgets/dialog_header.dart';
import 'widgets/filters_section.dart';
import 'widgets/locations_list.dart';

/// A reusable dialog for selecting service points/pickup locations
///
/// This dialog displays a list of service points with map integration,
/// search filters, and category selection. It's designed to be used
/// across different features without any external dependencies.
///
/// Usage:
/// ```dart
/// final result = await ServicePointSelectionDialog.show(
///   context: context,
///   servicePoints: servicePointsList,
///   productName: 'iPhone Case', // optional
///   onRadiusChanged: (radius) => fetchNewLocations(radius), // optional
///   onSearchAgain: () => refreshLocations(), // optional
/// );
///
/// if (result != null) {
///   print('Selected: ${result.name}');
/// }
/// ```
class ServicePointSelectionDialog extends StatefulWidget {
  const ServicePointSelectionDialog({
    required this.servicePoints,
    this.productName,
    this.onRadiusChanged,
    this.onCategoryChanged,
    this.initialRadius = SearchRadius.km2,
    this.initialCategory = ServicePointCategory.all,
    this.isLoading = false,
    super.key,
  });

  /// List of service points to display
  final List<ServicePointModel> servicePoints;

  /// Optional product name to display in the header
  final String? productName;

  /// Callback when radius is changed - should trigger API call with new radius
  final Function(SearchRadius radius)? onRadiusChanged;

  /// Callback when category filter is changed
  final Function(ServicePointCategory category)? onCategoryChanged;

  /// Whether the dialog is currently loading new service points
  final bool isLoading;

  /// Initial selected radius
  final SearchRadius initialRadius;

  /// Initial selected category
  final ServicePointCategory initialCategory;

  /// Show the dialog and return the selected service point
  static Future<ServicePointModel?> show({
    required BuildContext context,
    required List<ServicePointModel> servicePoints,
    String? productName,
    Function(SearchRadius radius)? onRadiusChanged,
    Function(ServicePointCategory category)? onCategoryChanged,
    SearchRadius initialRadius = SearchRadius.km2,
    ServicePointCategory initialCategory = ServicePointCategory.all,
    bool isLoading = false,
  }) async {
    return showDialog<ServicePointModel>(
      context: context,
      builder: (BuildContext context) => ServicePointSelectionDialog(
        servicePoints: servicePoints,
        productName: productName,
        onRadiusChanged: onRadiusChanged,
        onCategoryChanged: onCategoryChanged,
        initialRadius: initialRadius,
        initialCategory: initialCategory,
        isLoading: isLoading,
      ),
    );
  }

  @override
  State<ServicePointSelectionDialog> createState() =>
      _ServicePointSelectionDialogState();
}

class _ServicePointSelectionDialogState
    extends State<ServicePointSelectionDialog> {
  late ServicePointDialogState _state;

  @override
  void initState() {
    super.initState();
    _state = ServicePointDialogState(
      selectedRadius: widget.initialRadius,
      selectedCategory: widget.initialCategory,
      servicePoints: widget.servicePoints,
      selectedPoint: widget.servicePoints.isNotEmpty
          ? widget.servicePoints.first
          : null,
    );
  }

  @override
  void didUpdateWidget(covariant ServicePointSelectionDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.servicePoints != widget.servicePoints) {
      _state = _state.copyWith(servicePoints: widget.servicePoints);
    }
  }

  void _selectServicePoint(ServicePointModel point) {
    setState(() {
      _state = _state.copyWith(selectedPoint: point);
    });
  }

  void _handleRadiusChange(SearchRadius radius) {
    setState(() {
      _state = _state.copyWith(selectedRadius: radius);
    });
    widget.onRadiusChanged?.call(radius);
  }

  void _handleCategoryChange(ServicePointCategory category) {
    setState(() {
      _state = _state.copyWith(selectedCategory: category);

      // Reset selected point if it doesn't match the new filter
      if (_state.selectedPoint != null &&
          !_state.filteredServicePoints.contains(_state.selectedPoint)) {
        _state = _state.copyWith(
          selectedPoint: _state.filteredServicePoints.isNotEmpty
              ? _state.filteredServicePoints.first
              : null,
        );
      }
    });
    widget.onCategoryChanged?.call(category);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: size.width,
        height: size.height * 0.85,
        child: Column(
          children: <Widget>[
            const DialogHeader(),
            Expanded(
              child: Column(
                children: <Widget>[
                  FiltersSection(
                    selectedRadius: _state.selectedRadius,
                    selectedCategory: _state.selectedCategory,
                    onRadiusChanged: _handleRadiusChange,
                    onCategoryChanged: _handleCategoryChange,
                    productName: widget.productName,
                  ),
                  Expanded(
                    child: LocationsList(
                      servicePoints: _state.filteredServicePoints,
                      selectedPoint: _state.selectedPoint,
                      selectedCategory: _state.selectedCategory,
                      onLocationTap: _selectServicePoint,
                      isLoading: widget.isLoading,
                    ),
                  ),
                ],
              ),
            ),
            DialogFooter(selectedPoint: _state.selectedPoint),
          ],
        ),
      ),
    );
  }
}
