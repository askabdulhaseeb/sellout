import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../../business/business_page/views/widgets/section_details/empty_lists/business_page_empty_service_widget.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../marketplace/domain/params/filter_params.dart';
import '../../../../../services/domain/params/services_by_filters_params.dart';
import '../../../../../services/domain/usecase/get_services_by_query_usecase.dart';
import '../../../data/models/service_employee_model.dart';
import '../../../domain/entites/service_employee_entity.dart';
import '../../provider/quote_provider.dart';

class StepServices extends StatefulWidget {
  const StepServices({required this.businessId, super.key});
  final String businessId;

  @override
  State<StepServices> createState() => _StepServicesState();
}

class _StepServicesState extends State<StepServices> {
  final GetServicesByQueryUsecase _servicesUsecase = GetServicesByQueryUsecase(
    locator(),
  );

  final ScrollController _scrollController = ScrollController();
  final List<ServiceEntity> _services = <ServiceEntity>[];
  String _lastKey = '';
  bool _hasMore = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchServices(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          !_isLoading &&
          _hasMore) {
        _fetchServices();
      }
    });
  }

  ServiceByFiltersParams get _servicesParam => ServiceByFiltersParams(
    lastKey: _lastKey,
    query: '', // you can add a search box later if needed
    filters: <FilterParam>[
      FilterParam(
        attribute: 'business_id',
        operator: 'eq',
        value: widget.businessId,
      ),
    ],
  );

  Future<void> _fetchServices({bool reset = false}) async {
    if (widget.businessId.isEmpty) return;
    if (reset) {
      _lastKey = '';
      _services.clear();
      _hasMore = true;
      _errorMessage = null;
    }
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final DataState<List<ServiceEntity>> result = await _servicesUsecase.call(
        _servicesParam,
      );

      if (result is DataSuccess) {
        final List<ServiceEntity> fetched = result.entity ?? <ServiceEntity>[];
        if (reset) _services.clear();
        _services.addAll(fetched);
        _lastKey = result.data ?? '';
        _hasMore = result.data != '';
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load data';
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _hasMore = false;
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _services.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_services.isEmpty) {
      return const BusinessPageEmptyServiceWidget();
    }

    return Column(
      children: <Widget>[
        /// Services grid
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemCount: _services.length + (_isLoading ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index >= _services.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final ServiceEntity service = _services[index];
              return _ServiceStepGridTile(service: service);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _ServiceStepGridTile extends StatelessWidget {
  const _ServiceStepGridTile({required this.service});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    final QuoteProvider quoteProvider = context.watch<QuoteProvider>();
    final int qty = quoteProvider.selectedServices
        .where((ServiceEmployeeEntity s) => s.serviceId == service.serviceID)
        .map((ServiceEmployeeEntity s) => s.quantity)
        .fold(0, (int a, int b) => a + b);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Service name
          Text(
            service.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),

          /// Price + time
          Row(
            children: <Widget>[
              Text(
                service.priceStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${service.time} ${'min'.tr()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  bgColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.0),
                  border: Border.all(color: Theme.of(context).primaryColor),
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  title: 'add'.tr(),
                  isLoading: false,
                  onTap: () => quoteProvider.addService(
                    ServiceEmployeeModel(
                      serviceId: service.serviceID,
                      quantity: 1,
                    ),
                  ),
                ),
              ),
              if (qty > 0) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '$qty',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomElevatedButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    bgColor: Colors.transparent,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.2,
                    ),
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                    title: 'remove'.tr(),
                    isLoading: false,
                    onTap: () => quoteProvider.removeService(service.serviceID),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
