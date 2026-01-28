import '../../../../../../../../../../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../../../../../../features/personal/auth/signin/data/sources/local/local_auth.dart';

class AddressUtils {
  static AddressEntity? getDefaultAddress() {
    final List<AddressEntity> addresses =
        LocalAuth.currentUser?.address ?? <AddressEntity>[];
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }
}
