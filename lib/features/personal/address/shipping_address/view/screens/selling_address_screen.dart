import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/bottom_sheets/widgets/address_tile.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../add_address/views/screens/add_selling_address_screen.dart';

class SellingAddressScreen extends StatefulWidget {
  const SellingAddressScreen({super.key});
  static const String routeName = '/shipping-address';

  @override
  State<SellingAddressScreen> createState() => _SellingAddressScreenState();
}

class _SellingAddressScreenState extends State<SellingAddressScreen> {
  AddressEntity? selectedAddress;

  Future<void> _pickOrAddAddress({AddressEntity? initial}) async {
    await Navigator.of(context).push<AddressEntity?>(
      MaterialPageRoute<AddressEntity?>(
        builder: (BuildContext context) =>
            AddEditSellingAddressScreen(initAddress: initial),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(
          onPressed: () => Navigator.of(context).canPop()
              ? Navigator.pop(context)
              : Provider.of<PersonalBottomNavProvider>(
                  context,
                  listen: false,
                ).setCurrentTab(PersonalBottomNavBarType.home),
        ),
        title: AppBarTitle(titleKey: 'selling_address'.tr()),
      ),
      body: ValueListenableBuilder<List<AddressEntity>>(
        valueListenable: LocalAuth.addressListNotifier,
        builder: (BuildContext context, List<AddressEntity> addresses, _) {
          final AddressEntity? addressToShow = LocalAuth.sellingAddress;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (addressToShow != null)
                  AddressTile(address: addressToShow, onTap: () {}),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  title: addressToShow == null
                      ? 'add_a_new_address'.tr()
                      : 'change_address'.tr(),
                  isLoading: false,
                  onTap: () => _pickOrAddAddress(initial: addressToShow),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
