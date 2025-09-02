import '../../../marketplace/domain/params/filter_params.dart';
import 'service_sort_options.dart';

class ServiceByFiltersParams {
  ServiceByFiltersParams({
    required this.filters,
    this.query,
    this.distance,
    this.clientLat,
    this.clientLng,
    this.lastKey,
    this.category,
    this.sort,
  });
  final List<FilterParam> filters;
  final String? query;
  final String? category;
  final int? distance;
  final double? clientLat;
  final double? clientLng;
  final String? lastKey;
  final ServiceSortOption? sort;
}
