import 'package:flutter/material.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../services/get_it.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../../services/domain/params/services_by_filters_params.dart';
import '../../../../services/domain/usecase/get_services_by_query_usecase.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({required this.businessId, super.key});
  final String businessId;

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final GetServicesByQueryUsecase _servicesUsecase =
      GetServicesByQueryUsecase(locator());
  final ScrollController _scrollController = ScrollController();
  final List<ServiceEntity> _services = <ServiceEntity>[];
  String _lastKey = '';
  bool _hasMore = true;
  bool _isLoading = false;

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

  Future<void> _fetchServices({bool reset = false}) async {
    if (reset) {
      _lastKey = '';
      _services.clear();
      _hasMore = true;
    }
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);

    final DataState<List<ServiceEntity>> result = await _servicesUsecase.call(ServiceByFiltersParams(
      lastKey: _lastKey,
      query: '',
      filters: <FilterParam>[
        FilterParam(
            attribute: 'business_id', operator: 'eq', value: widget.businessId),
      ],
    ));

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Services')),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: _services.length + (_isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index >= _services.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final ServiceEntity service = _services[index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomNetworkImage(
                    imageURL: service.thumbnailURL, size: 40),
              ),
              title: Text(service.name),
              trailing: ElevatedButton(
                onPressed: () {
                  // // add service + open quantity selector
                  // Provider.of<QuoteProvider>(context, listen: false)
                  //     .addService(service, 1);
                },
                child: const Text('Add'),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => BookQuoteScreen(service: )), // step 2
            // );
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
