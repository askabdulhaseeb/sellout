import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/postage/data/models/service_points_response_model.dart';
import '../../constants/app_spacings.dart';
import 'enums/service_point_enums.dart';
import 'widgets/filters_section.dart';
import 'widgets/location_card.dart';

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
  ServicePointModel? _selectedPoint;
  late SearchRadius _selectedRadius;
  late ServicePointCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.initialRadius;
    _selectedCategory = widget.initialCategory;
    _selectedPoint = widget.servicePoints.isNotEmpty
        ? widget.servicePoints.first
        : null;
  }

  void _selectServicePoint(ServicePointModel point) {
    setState(() => _selectedPoint = point);
  }

  void _handleRadiusChange(SearchRadius radius) {
    setState(() => _selectedRadius = radius);
    widget.onRadiusChanged?.call(radius);
  }

  void _handleCategoryChange(ServicePointCategory category) {
    setState(() {
      _selectedCategory = category;
      // Reset selected point if it doesn't match the new filter
      if (_selectedPoint != null &&
          !_filteredServicePoints.contains(_selectedPoint)) {
        _selectedPoint = _filteredServicePoints.isNotEmpty
            ? _filteredServicePoints.first
            : null;
      }
    });
    widget.onCategoryChanged?.call(category);
  }

  /// Get filtered service points based on selected category
  List<ServicePointModel> get _filteredServicePoints {
    if (_selectedCategory == ServicePointCategory.all) {
      return widget.servicePoints;
    }

    return widget.servicePoints.where((ServicePointModel point) {
      final String type = point.type.toLowerCase();

      // Match category with point type
      switch (_selectedCategory) {
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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
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
            _buildGradientHeader(textTheme, colorScheme),
            Expanded(
              child: Column(
                children: <Widget>[
                  _buildFiltersSection(textTheme, colorScheme),
                  Expanded(child: _buildLocationsList(textTheme, colorScheme)),
                ],
              ),
            ),
            _buildFooter(textTheme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_pin,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'select_pickup_location'.tr(),
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(TextTheme textTheme, ColorScheme colorScheme) {
    return FiltersSection(
      selectedRadius: _selectedRadius,
      selectedCategory: _selectedCategory,
      onRadiusChanged: _handleRadiusChange,
      onCategoryChanged: _handleCategoryChange,
      productName: widget.productName,
    );
  }

  Widget _buildLocationsList(TextTheme textTheme, ColorScheme colorScheme) {
    // Show loading state
    if (widget.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'finding_pickup_locations'.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final List<ServicePointModel> filteredPoints = _filteredServicePoints;

    if (filteredPoints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'no_locations_found'.tr(
                namedArgs: <String, String>{'category': _selectedCategory.key},
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'try_different_category'.tr(),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredPoints.length,
      itemBuilder: (BuildContext context, int index) {
        final ServicePointModel point = filteredPoints[index];
        return LocationCard(
          point: point,
          isSelected: _selectedPoint?.id == point.id,
          onTap: () => _selectServicePoint(point),
        );
      },
    );
  }

  Widget _buildFooter(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Text('cancel'.tr()),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: _selectedPoint != null
                  ? () => Navigator.pop(context, _selectedPoint)
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.outline,
              ),
              child: Text(
                'confirm_pickup_location'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
