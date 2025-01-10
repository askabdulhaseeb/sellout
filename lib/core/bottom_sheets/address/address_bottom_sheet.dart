import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/data/models/address_model.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/in_dev_mode.dart';
import '../widgets/bottom_sheet_top_bar.dart';
import '../widgets/selectable_address_tile.dart';

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({this.initAddress, super.key});
  final AddressEntity? initAddress;

  @override
  Widget build(BuildContext context) {
    final List<AddressEntity> addresses =
        LocalAuth.currentUser?.address ?? <AddressEntity>[];
    return BottomSheetCore(
      title: 'address'.tr(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: addresses.length,
              itemBuilder: (BuildContext context, int index) {
                final AddressEntity address = addresses[index];
                return SelectableAddressTile(
                  address: address,
                  isSelected: address == initAddress,
                  onTap: () {
                    Navigator.of(context).pop(address);
                  },
                );
              },
            ),
            const Divider(),
            const Text(
              'add-a-delivery-or-pickup-address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ).tr(),
            CustomElevatedButton(
              title: 'add-a-new-address'.tr(),
              isLoading: false,
              onTap: () async {
                final AddressEntity? newAddress =
                    await Navigator.of(context).push<AddressEntity?>(
                  MaterialPageRoute<AddressEntity?>(
                    builder: (BuildContext context) {
                      return const AddEditAddressScreen();
                    },
                  ),
                );
                if (newAddress != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(newAddress);
                }
              },
            ),
            InDevMode(
              child: CustomElevatedButton(
                title: 'find-pickup-location-near-you'.tr(),
                isLoading: false,
                onTap: () {},
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
