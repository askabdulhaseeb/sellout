class PackageDetail {
  const PackageDetail({
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });
  final int length;
  final int width;
  final int height;
  final int weight;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
      };
}
