import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/address/add_address/views/provider/add_address_provider.dart';
import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../widgets/custom_elevated_button.dart';

class SelectableAddressTile extends StatelessWidget {
  const SelectableAddressTile({
    required this.address,
    required this.onTap,
    this.padding,
    this.isSelected = false,
    super.key,
  });

  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorScheme.of(context).outlineVariant)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Icon(
                isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              address.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          if (address.isDefault)
                            Text(
                              ' (${'default'.tr().toUpperCase()})',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const Text('  •  '),
                        ],
                      ),
                      Text('${address.recipientName} . ${address.phoneNumber}'),
                      Text('${address.city} . ${address.postalCode}'),
                      Text(address.address),
                      const SizedBox(height: 8),
                      CustomElevatedButton(
                        bgColor: ColorScheme.of(context).secondary,
                        title: 'edit'.tr(),
                        isLoading: false,
                        onTap: () async {
                          AddAddressProvider pro =
                              Provider.of<AddAddressProvider>(context,
                                  listen: false);
                          pro.updateVariable(address);
                          Navigator.of(context).push<AddressEntity?>(
                            MaterialPageRoute<AddressEntity?>(
                              builder: (BuildContext context) {
                                return AddEditAddressScreen(
                                    initAddress: address);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
