class GetBusinessSerivesParam {
  const GetBusinessSerivesParam({
    required this.businessID,
    this.sort = 'lowToHigh',
    this.nextKey,
  });

  final String businessID;
  final String? nextKey;
  final String sort;
}
