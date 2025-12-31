import '../../models/wallet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalWallet {
  static const String _walletKey = 'local_wallet';

  Future<void> saveWallet(WalletModel wallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletKey, wallet.toJsonString());
  }

  Future<WalletModel?> getWallet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? walletJson = prefs.getString(_walletKey);
    if (walletJson == null) return null;
    return WalletModel.fromJsonString(walletJson);
  }

  Future<void> clearWallet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_walletKey);
  }
}
