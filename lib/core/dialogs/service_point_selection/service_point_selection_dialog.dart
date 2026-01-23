import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../features/postage/data/models/service_points_response_model.dart';
import '../../constants/app_spacings.dart';

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
    this.title = 'Select Pickup Location',
    this.onRadiusChanged,
    this.onCategoryChanged,
    this.availableRadii = const <String>['500m', '1 km', '2 km', '5 km'],
    this.availableCategories = const <String>[
      'All',
      'Shops',
      'Lockers',
      'Post',
    ],
    this.initialRadius = '2 km',
    this.initialCategory = 'All',
      this.isLoading = false,
    super.key,
  });

  /// List of service points to display
  final List<ServicePointModel> servicePoints;

  /// Optional product name to display in the header
  final String? productName;

  /// Dialog title
  final String title;

  /// Callback when radius is changed - should trigger API call with new radius
  final Function(String radius)? onRadiusChanged;

  /// Callback when category filter is changed
  final Function(String category)? onCategoryChanged;

  /// Whether the dialog is currently loading new service points
  final bool isLoading;

  /// Available radius options
  final List<String> availableRadii;

  /// Available category options
  final List<String> availableCategories;

  /// Initial selected radius
  final String initialRadius;

  /// Initial selected category
  final String initialCategory;

  /// Show the dialog and return the selected service point
  static Future<ServicePointModel?> show({
    required BuildContext context,
    required List<ServicePointModel> servicePoints,
    String? productName,
    String title = 'Select Pickup Location',
    Function(String radius)? onRadiusChanged,
    Function(String category)? onCategoryChanged,
    List<String> availableRadii = const <String>[
      '500m',
      '1 km',
      '2 km',
      '5 km',
    ],
    List<String> availableCategories = const <String>[
      'All',
      'Shops',
      'Lockers',
      'Post',
    ],
    String initialRadius = '2 km',
    String initialCategory = 'All',
    bool isLoading = false,
  }) async {
    return showDialog<ServicePointModel>(
      context: context,
      builder: (BuildContext context) => ServicePointSelectionDialog(
        servicePoints: servicePoints,
        productName: productName,
        title: title,
        onRadiusChanged: onRadiusChanged,
        onCategoryChanged: onCategoryChanged,
        availableRadii: availableRadii,
        availableCategories: availableCategories,
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
  late MapController _mapController;
  ServicePointModel? _selectedPoint;
  late String _selectedRadius;
  late String _selectedCategory;

  static const Color _primaryRed = Color(0xFFC4001A);
  static const Color _tealAccent = Color(0xFF00A991);
  static const Color _borderGray = Color(0xFFE0E0E0);
  static const Color _textSecondary = Color(0xFF666666);
  static const Color _badgePurple = Color(0xFF8E44AD);
  static const Color _badgeBlue = Color(0xFF3498DB);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedRadius = widget.initialRadius;
    _selectedCategory = widget.initialCategory;
    _selectedPoint = widget.servicePoints.isNotEmpty
        ? widget.servicePoints.first
        : null;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _selectServicePoint(ServicePointModel point) {
    setState(() => _selectedPoint = point);
    _mapController.move(LatLng(point.latitude, point.longitude), 15);
  }

  void _handleRadiusChange(String radius) {
    setState(() => _selectedRadius = radius);
    widget.onRadiusChanged?.call(radius);
  }

  void _handleCategoryChange(String category) {
    setState(() {
      _selectedCategory = category;
      // Reset selected point if it doesn't match the new filter
      if (_selectedPoint != null && !_filteredServicePoints.contains(_selectedPoint)) {
        _selectedPoint = _filteredServicePoints.isNotEmpty
            ? _filteredServicePoints.first
            : null;
      }
    });
    widget.onCategoryChanged?.call(category);
  }

  /// Get filtered service points based on selected category
  List<ServicePointModel> get _filteredServicePoints {
    if (_selectedCategory == 'All') {
      return widget.servicePoints;
    }
    
    return widget.servicePoints.where((ServicePointModel point) {
      final String type = point.type.toLowerCase();
      final String category = _selectedCategory.toLowerCase();
      
      // Match category with point type
      if (category == 'shops' && type.contains('shop')) return true;
      if (category == 'lockers' && type.contains('locker')) return true;
      if (category == 'post' && (type.contains('post') || type.contains('office'))) return true;
      
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 50 : 16,
        vertical: 24,
      ),
      child: SizedBox(
        width: isDesktop ? 1200 : size.width,
        height: size.height * 0.85,
        child: Column(
          children: <Widget>[
            _buildGradientHeader(textTheme),
            Expanded(
              child: isDesktop
                  ? _buildDesktopLayout(textTheme)
                  : _buildMobileLayout(textTheme),
            ),
            _buildFooter(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader(TextTheme textTheme) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[_primaryRed, _tealAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
            child: const Icon(Icons.location_pin, color: _primaryRed, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredServicePoints.length} of ${widget.servicePoints.length} Locations',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
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

  Widget _buildDesktopLayout(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        Expanded(flex: 4, child: _buildLeftPanel(textTheme)),
        const VerticalDivider(width: 1),
        Expanded(flex: 6, child: _buildRightPanel(textTheme)),
      ],
    );
  }

  Widget _buildMobileLayout(TextTheme textTheme) {
    return Column(
      children: <Widget>[
        SizedBox(height: 220, child: _buildFiltersSection(textTheme)),
        Expanded(
          flex: 3,
          child: _selectedPoint != null
              ? _buildMap(_selectedPoint!)
              : const Center(child: Text('No locations available')),
        ),
        Expanded(flex: 4, child: _buildLocationsList(textTheme)),
      ],
    );
  }

  Widget _buildLeftPanel(TextTheme textTheme) {
    return Column(
      children: <Widget>[
        _buildFiltersSection(textTheme),
        Expanded(child: _buildLocationsList(textTheme)),
      ],
    );
  }

  Widget _buildRightPanel(TextTheme textTheme) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _selectedPoint != null
              ? _buildMap(_selectedPoint!)
              : const Center(child: Text('No locations available')),
        ),
        if (_selectedPoint != null)
          Expanded(
            flex: 2,
            child: _buildLocationDetails(_selectedPoint!, textTheme),
          ),
      ],
    );
  }

  Widget _buildFiltersSection(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: const Border(bottom: BorderSide(color: _borderGray)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.productName != null) ...<Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.inventory_2_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Applying to: ${widget.productName}',
                      style: textTheme.bodySmall?.copyWith(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text('Search Radius', style: textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.availableRadii
                  .map((String radius) => _buildRadiusChip(radius))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Category', style: textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.availableCategories
                  .map((String category) => _buildCategoryChip(category))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusChip(String radius) {
    final bool isSelected = _selectedRadius == radius;
    return ChoiceChip(
      label: Text(radius),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) _handleRadiusChange(radius);
      },
      selectedColor: _primaryRed.withValues(alpha: 0.1),
      side: BorderSide(
        color: isSelected ? _primaryRed : _borderGray,
        width: isSelected ? 2 : 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? _primaryRed : _textSecondary,
        fontSize: 12,
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final bool isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) _handleCategoryChange(category);
      },
      selectedColor: _primaryRed,
      checkmarkColor: Colors.white,
      side: BorderSide(color: isSelected ? _primaryRed : _borderGray, width: 1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : _textSecondary,
        fontSize: 12,
      ),
    );
  }

  Widget _buildLocationsList(TextTheme textTheme) {
        // Show loading state
        if (widget.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryRed),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Finding pickup locations near you...',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _textSecondary,
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
              'No ${_selectedCategory.toLowerCase()} locations found',
              style: textTheme.bodyMedium?.copyWith(color: _textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category',
              style: textTheme.bodySmall?.copyWith(color: _textSecondary),
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
        return _buildLocationCard(point, textTheme);
      },
    );
  }

  Widget _buildLocationCard(ServicePointModel point, TextTheme textTheme) {
    final bool isSelected = _selectedPoint?.id == point.id;

    return GestureDetector(
      onTap: () => _selectServicePoint(point),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? _primaryRed : _borderGray,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            if (isSelected)
              BoxShadow(
                color: _primaryRed.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Radio<String>(
              value: point.id.toString(),
              groupValue: _selectedPoint?.id.toString(),
              onChanged: (String? value) => _selectServicePoint(point),
              activeColor: _primaryRed,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    point.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: <Widget>[
                      _buildBadge(point.type, _badgePurple),
                      _buildBadge(point.distance.toString(), _badgeBlue),
                      _buildBadge(point.carrier, Colors.orange[700]!),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${point.address}${', ${point.city}'}',
                    style: textTheme.bodySmall?.copyWith(
                      color: _textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ...<Widget>[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: point.isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        point.isActive ? 'Open Now' : 'Closed',
                        style: textTheme.labelSmall?.copyWith(
                          color: point.isActive ? Colors.green : Colors.red,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isSelected ? _primaryRed : _borderGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationDetails(ServicePointModel point, TextTheme textTheme) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderGray)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    point.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildBadge(point.distance.toString(), _badgeBlue),
              ],
            ),
            const SizedBox(height: 4),
            _buildBadge(point.type, _badgePurple),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${point.address}${', ${point.city}'}',
              style: textTheme.bodySmall?.copyWith(color: _textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Opening Hours',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildOpeningHoursTable(point.openingHours, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHoursTable(
    Map<String, List<String>> openingHours,
    TextTheme textTheme,
  ) {
    final List<MapEntry<String, List<String>>> entries = openingHours.entries
        .toList();
    final int currentDay = DateTime.now().weekday % 7;
    final List<String> dayNames = <String>[
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    return Column(
      children: entries.map((MapEntry<String, List<String>> entry) {
        // entry.key is day number as string (0-6)
        final int dayIndex = int.tryParse(entry.key) ?? -1;
        final bool isToday = dayIndex == currentDay;
        final String dayName = dayIndex >= 0 && dayIndex < dayNames.length
            ? dayNames[dayIndex]
            : entry.key;
        final String times = entry.value.join(', ');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  dayName,
                  style: textTheme.bodySmall?.copyWith(
                    color: isToday ? _primaryRed : _textSecondary,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  times,
                  textAlign: TextAlign.end,
                  style: textTheme.bodySmall?.copyWith(
                    color: isToday ? _primaryRed : _textSecondary,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderGray)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: _borderGray),
              ),
              child: const Text('Cancel'),
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
                backgroundColor: _primaryRed,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _borderGray,
              ),
              child: const Text(
                'Confirm Pickup Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(ServicePointModel point) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(point.latitude, point.longitude),
        initialZoom: 15,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sellout.sellout',
        ),
        MarkerLayer(
          markers: _filteredServicePoints
              .map(
                (ServicePointModel sp) => Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(sp.latitude, sp.longitude),
                  child: GestureDetector(
                    onTap: () => _selectServicePoint(sp),
                    child: Icon(
                      Icons.location_pin,
                      color: sp.id == _selectedPoint?.id
                          ? _primaryRed
                          : _badgeBlue,
                      size: sp.id == _selectedPoint?.id ? 40 : 32,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
