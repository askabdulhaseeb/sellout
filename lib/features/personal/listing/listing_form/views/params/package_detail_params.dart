import 'dart:convert';

class PackageDetail {
  /// Optional: fromJson factory for completeness
  factory PackageDetail.fromJson(String source) {
    final Map<String, dynamic> data = jsonDecode(source);
    return PackageDetail(
      length: data['length'] ?? 0,
      width: data['width'] ?? 0,
      height: data['height'] ?? 0,
      weight: data['weight'] ?? 0,
    );
  }
  const PackageDetail({
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  final String length;
  final String width;
  final String height;
  final String weight;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'length': length,
        'width': width,
        'height': height,
        'weight': weight
      };
}
