// Contains logic for grouping package size by dimensions.
String groupBySize(List<dynamic> dims) {
  final double volume =
      (dims[0] as num).toDouble() *
      (dims[1] as num).toDouble() *
      (dims[2] as num).toDouble();
  if (volume <= 2000) {
    return 'small';
  } else if (volume <= 50000) {
    return 'medium';
  } else {
    return 'large';
  }
}
