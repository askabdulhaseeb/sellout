import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/searchable_textfield.dart';
import '../../../../../../services/get_it.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../../services/domain/params/services_by_filters_params.dart';
import '../../../../services/domain/usecase/get_services_by_query_usecase.dart';

class ServiceDropdown extends StatefulWidget {
  const ServiceDropdown({
    required this.businessId,
    required this.onSelected,
    super.key,
  });

  final String businessId;
  final void Function(ServiceEntity service) onSelected;

  @override
  State<ServiceDropdown> createState() => _ServiceDropdownState();
}

class _ServiceDropdownState extends State<ServiceDropdown>
    with SingleTickerProviderStateMixin {
  final GetServicesByQueryUsecase _servicesListUsecase =
      GetServicesByQueryUsecase(locator());

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  final List<ServiceEntity> _services = <ServiceEntity>[];
  String _lastKey = '';
  bool _hasMore = true;
  bool _isLoading = false;

  OverlayEntry? _overlayEntry;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fetchServices(reset: true);

    // Scroll load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !_isLoading &&
          _hasMore) {
        _fetchServices();
      }
    });

    // Show overlay on focus
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  ServiceByFiltersParams get _servicesParam => ServiceByFiltersParams(
        lastKey: _lastKey,
        query: _searchController.text,
        filters: <FilterParam>[
          FilterParam(
            attribute: 'business_id',
            operator: 'eq',
            value: widget.businessId,
          ),
        ],
      );

  Future<void> _fetchServices({bool reset = false}) async {
    if (reset) {
      _lastKey = '';
      _services.clear();
      _hasMore = true;
    }
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);

    final DataState<List<ServiceEntity>> result =
        await _servicesListUsecase.call(_servicesParam);

    if (result is DataSuccess) {
      final List<ServiceEntity> fetched = result.entity ?? <ServiceEntity>[];
      if (reset) _services.clear();
      _services.addAll(fetched);
      _lastKey = result.data ?? '';
      _hasMore = result.data != '';
    } else {
      _hasMore = false;
    }

    setState(() => _isLoading = false);
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _removeOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  double _overlayHeight() {
    final int count = _services.length + (_isLoading ? 1 : 0);
    const double itemHeight = 56;
    const double maxHeight = 250;
    final double height = count * itemHeight;
    return height > maxHeight ? maxHeight : height;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: SizedBox(
                      height: _overlayHeight(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: _services.isEmpty && !_isLoading
                            ? 1
                            : _services.length + (_isLoading ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          (BuildContext context, int index) {
                            // 1️⃣ If no results and not loading
                            if (_services.isEmpty && !_isLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }

                            // 2️⃣ Loading at the bottom
                            if (index >= _services.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            // 3️⃣ Normal items
                            final ServiceEntity service = _services[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CustomNetworkImage(
                                  imageURL: service.thumbnailURL,
                                  size: 40,
                                ),
                              ),
                              title: Text(
                                service.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              onTap: () {
                                widget.onSelected(service);
                                _focusNode.unfocus();
                                _removeOverlay();
                              },
                            );
                          };
                          final ServiceEntity service = _services[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CustomNetworkImage(
                                imageURL: service.thumbnailURL,
                                size: 40,
                              ),
                            ),
                            title: Text(
                              service.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              widget.onSelected(service);
                              _focusNode.unfocus();
                              _removeOverlay();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SearchableTextfield(
        controller: _searchController,
        focusNode: _focusNode,
        hintText: 'search'.tr(),
        onChanged: (String _) {
          _fetchServices(reset: true);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
