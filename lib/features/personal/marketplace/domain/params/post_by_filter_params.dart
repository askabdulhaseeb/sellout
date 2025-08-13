import '../../views/enums/sort_enums.dart';
import 'filter_params.dart';

class PostByFiltersParams {
  PostByFiltersParams({
    required this.filters,
    this.size = const <String>[],
    this.colors = const <String>[],
    this.query,
    this.distance,
    this.clientLat,
    this.clientLng,
    this.address,
    this.lastKey,
    this.category,
    this.sort,
  });
  final List<FilterParam> filters;
  final List<String> size;
  final List<String> colors;
  final String? query;
  final dynamic category;
  final int? distance;
  final double? clientLat;
  final double? clientLng;
  final String? address;
  final String? lastKey;
  final SortOption? sort;
}
