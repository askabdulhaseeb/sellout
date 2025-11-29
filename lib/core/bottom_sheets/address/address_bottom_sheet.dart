import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/in_dev_mode.dart';
import '../widgets/selectable_address_tile.dart';

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({this.initAddress, super.key});
  final AddressEntity? initAddress;

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  AddressEntity? selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.initAddress;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AddressEntity>>(
      valueListenable: LocalAuth.addressListNotifier,
      builder: (BuildContext context, List<AddressEntity> addresses, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            backgroundBlendMode: BlendMode.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Divider(),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: addresses.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AddressEntity address = addresses[index];
                          final bool isSelected = address == selectedAddress;
                          return SelectableAddressTile(
                            address: address,
                            isSelected: isSelected,
                            showButtons: isSelected,
                            onTap: () {
                              if (isSelected) {
                                Navigator.of(context).pop(address);
                              } else {
                                setState(() {
                                  selectedAddress = address;
                                });
                              }
                            },
                          );
                        },
                      ),
                      const Divider(),
                      const Text(
                        'add_a_delivery_or_pickup_address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ).tr(),
                      CustomElevatedButton(
                        textColor: Theme.of(context).primaryColor,
                        border: Border.all(
                            color: ColorScheme.of(context).outlineVariant),
                        bgColor: Colors.transparent,
                        title: 'add_a_new_address'.tr(),
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
                          textColor: Theme.of(context).primaryColor,
                          border: Border.all(
                            color: ColorScheme.of(context).outlineVariant,
                          ),
                          bgColor: Colors.transparent,
                          title: 'find_pickup_location_near_you'.tr(),
                          isLoading: false,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
