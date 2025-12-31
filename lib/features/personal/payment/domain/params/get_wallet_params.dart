class GetWalletParams {
  const GetWalletParams({required this.walletId, this.refresh = false});
  final String walletId;
  final bool refresh;
}
