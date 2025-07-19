import 'dart:convert';
import '../../views/enums/sort_enums.dart';
import 'filter_params.dart';

class PostByFiltersParams {
  PostByFiltersParams({
    required this.filters,
    this.size,
    this.colors,
    this.distance,
    this.clientLat,
    this.clientLng,
    this.address,
    this.lastKey,
    this.category,
    this.sort,
  });
  final List<FilterParam> filters;
  final List<String>? size;
  final List<String>? colors;
  final String? category;
  final int? distance;
  final double? clientLat;
  final double? clientLng;
  final String? address;
  final String? lastKey;
  final SortOption? sort;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'distance': distance,
      'clientLat': clientLat,
      'clientLng': clientLng,
      'address': address,
      'lastKey': lastKey,
      'sort': sort,
      'size': size,
      'colors': colors,
      'filters': filters.map((FilterParam x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  // PostByFiltersParams copyWith({
  //   double? distance,
  //   double? clientLat,
  //   double? clientLng,
  //   String? address,
  //   String? lastKey,
  //   List<FilterParam>? filters,
  // }) {
  //   return PostByFiltersParams(
  //     distance: distance ?? this.distance,
  //     clientLat: clientLat ?? this.clientLat,
  //     clientLng: clientLng ?? this.clientLng,
  //     address: address ?? this.address,
  //     lastKey: lastKey ?? this.lastKey,
  //     filters: filters ?? this.filters,
  //   );
  // }
}
