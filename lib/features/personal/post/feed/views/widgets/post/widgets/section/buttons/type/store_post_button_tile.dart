import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../../core/extension/string_ext.dart';
import '../../../../../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../domain/entities/size_color/size_color_entity.dart';
import 'size_chart_button_tile.dart';
import 'widgets/post_add_to_basket_button.dart';
import 'widgets/post_buy_now_button.dart';
import 'widgets/post_make_offer_button.dart';

class StorePostButtonTile extends StatefulWidget {
  const StorePostButtonTile(
      {required this.post, required this.detailWidget, super.key});
  final PostEntity post;
  final bool detailWidget;

  @override
  State<StorePostButtonTile> createState() => _StorePostButtonTileState();
}

class _StorePostButtonTileState extends State<StorePostButtonTile> {
  SizeColorEntity? selectedSize;
  ColorEntity? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.post.type == ListingType.clothAndFoot && widget.detailWidget)
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: CustomDropdown<SizeColorEntity>(
                  title: '',
                  hint: 'select_your_size'.tr(),
                  items: widget.post.clothFootInfo!.sizeColors
                      .map((SizeColorEntity e) =>
                          DropdownMenuItem<SizeColorEntity>(
                            value: e,
                            child: Text(e.value),
                          ))
                      .toList(),
                  selectedItem: selectedSize,
                  onChanged: (SizeColorEntity? value) {
                    if (value != null) {
                      setState(() {
                        selectedSize = value;
                        selectedColor = null;
                      });
                    }
                  },
                  validator: (_) => null,
                ),
              ),
              Expanded(
                child: CustomDropdown<ColorEntity>(
                  title: '',
                  hint: 'select_color'.tr(),
                  items: (selectedSize?.colors ?? <ColorEntity>[])
                      .where((ColorEntity e) => e.quantity > 0)
                      .map((ColorEntity e) => DropdownMenuItem<ColorEntity>(
                            value: e,
                            child: Text(
                              e.code,
                              style: TextStyle(
                                color: e.code.toColor(),
                              ),
                            ),
                          ))
                      .toList(),
                  selectedItem: selectedColor,
                  onChanged: (ColorEntity? value) {
                    if (value != null) {
                      setState(() {
                        selectedColor = value;
                      });
                    }
                  },
                  validator: (_) => null,
                ),
              ),
            ],
          ),
        // Collection Section
        if (widget.post.deliveryType == DeliveryType.collection)
          _CollectionSection(
            post: widget.post,
            detailWidget: widget.detailWidget,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
          ),
        if (widget.post.deliveryType != DeliveryType.collection)
          _DeliverySection(
            post: widget.post,
            detailWidget: widget.detailWidget,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
          ),
        if (widget.post.type == ListingType.clothAndFoot && widget.detailWidget)
          SizeChartButtonTile(
              sizeChartURL: widget.post.clothFootInfo?.sizeChartUrl?.url ?? '')
      ],
    );
  }
}

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({
    required this.post,
    required this.detailWidget,
    this.selectedColor,
    this.selectedSize,
  });

  final PostEntity post;
  final bool detailWidget;
  final ColorEntity? selectedColor;
  final SizeColorEntity? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'delivery'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: PostBuyNowButton(
                  detailWidgetColor: selectedColor,
                  detailWidgetSize: selectedSize,
                  post: post,
                  detailWidget: detailWidget,
                ),
              ),
              if (post.acceptOffers == true)
                Expanded(
                  child: PostMakeOfferButton(
                    detailWidgetColor: selectedColor,
                    detailWidgetSize: selectedSize,
                    post: post,
                    detailWidget: detailWidget,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            children: <Widget>[
              Expanded(
                child: PostAddToBasketButton(
                  detailWidget: detailWidget,
                  detailWidgetColor: selectedColor,
                  detailWidgetSize: selectedSize,
                  post: post,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CollectionSection extends StatefulWidget {
  const _CollectionSection({
    required this.post,
    required this.detailWidget,
    this.selectedColor,
    this.selectedSize,
  });

  final PostEntity post;
  final bool detailWidget;
  final ColorEntity? selectedColor;
  final SizeColorEntity? selectedSize;

  @override
  State<_CollectionSection> createState() => _CollectionSectionState();
}

class _CollectionSectionState extends State<_CollectionSection> {
  LatLng? _userLocation;
  LatLng? _collectionPoint;

  @override
  void initState() {
    super.initState();
    _collectionPoint = LatLng(
      widget.post.collectionLatitude,
      widget.post.collectionLongitude,
    );
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, show dialog
        if (mounted) {
          _showLocationServiceDialog();
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          if (mounted) {
            _showPermissionDeniedDialog();
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        if (mounted) {
          _showPermissionDeniedForeverDialog();
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (mounted) {
        _showLocationErrorDialog(e.toString());
      }
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('location_services_disabled'.tr()),
          content: Text('please_enable_location_services'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text('open_settings'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('location_permission_denied'.tr()),
          content: Text('location_permission_required'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getUserLocation();
              },
              child: Text('retry'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('location_permission_denied'.tr()),
          content: Text('please_grant_location_permission_in_settings'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('open_settings'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('location_error'.tr()),
          content: Text('${'unable_to_get_location'.tr()}: $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCollectionWorkflow() async {
    // First ensure we have user location
    if (_userLocation == null) {
      await _getUserLocation();
    }

    // If we still don't have location, return early
    if (_userLocation == null) {
      return;
    }

    // Calculate distance between user and collection point
    double distanceInMeters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      _collectionPoint!.latitude,
      _collectionPoint!.longitude,
    );

    // Show collection workflow dialog
    _showCollectionWorkflowDialog(distanceInMeters);
  }

  void _showCollectionWorkflowDialog(double distanceInMeters) {
    _showCollectionBottomSheet(distanceInMeters);
  }

  void _showCollectionBottomSheet(double distanceInMeters) {
    double distanceInKm = distanceInMeters / 1000;
    String distanceText = distanceInKm < 1
        ? '${distanceInMeters.toInt()} meters'
        : '${distanceInKm.toStringAsFixed(1)} km';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _CollectionMapBottomSheet(
          userLocation: _userLocation!,
          collectionPoint: _collectionPoint!,
          distanceText: distanceText,
          post: widget.post,
          onConfirm: _proceedWithCollection,
        );
      },
    );
  }

  void _proceedWithCollection() {
    // TODO: Implement the actual collection logic
    // This could include:
    // - Adding item to collection queue
    // - Sending notification to store
    // - Creating collection appointment
    // - Navigating to collection confirmation screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('collection_confirmed'.tr()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Collection Point',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Icon(Icons.store, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Available for in-store collection',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tap to view location and confirm collection',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                title: 'View Location & Collect',
                isLoading: false,
                onTap: () => _handleCollectionWorkflow(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionMapBottomSheet extends StatefulWidget {
  const _CollectionMapBottomSheet({
    required this.userLocation,
    required this.collectionPoint,
    required this.distanceText,
    required this.post,
    required this.onConfirm,
  });

  final LatLng userLocation;
  final LatLng collectionPoint;
  final String distanceText;
  final PostEntity post;
  final VoidCallback onConfirm;

  @override
  State<_CollectionMapBottomSheet> createState() =>
      _CollectionMapBottomSheetState();
}

class _CollectionMapBottomSheetState extends State<_CollectionMapBottomSheet> {
  late final MapController _mapController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMapToBounds();
    });
  }

  void _fitMapToBounds() {
    final bounds = LatLngBounds.fromPoints([
      widget.userLocation,
      widget.collectionPoint,
    ]);

    // Add some padding around the bounds
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Collection Location',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Distance: ${widget.distanceText}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.collectionPoint,
                    initialZoom: 13,
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.sellout.sellout',
                    ),

                    // Polyline between user and collection point
                    PolylineLayer(
                      polylines: <Polyline<Object>>[
                        Polyline(
                          points: <LatLng>[
                            widget.userLocation,
                            widget.collectionPoint,
                          ],
                          color: Colors.teal,
                          strokeWidth: 3,
                          pattern: StrokePattern.dashed(segments: [10, 5]),
                        ),
                      ],
                    ),

                    // Markers
                    MarkerLayer(
                      markers: <Marker>[
                        // Collection point marker
                        Marker(
                          point: widget.collectionPoint,
                          width: 60,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.store,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),

                        // User location marker
                        Marker(
                          point: widget.userLocation,
                          width: 50,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Collection details and buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Collection Details',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Icon(Icons.store, color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Store Location',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Icon(Icons.access_time,
                              color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Available for collection',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('cancel'.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Confirm Collection'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate some processing time
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.of(context).pop();
      widget.onConfirm();
    }
  }
}
