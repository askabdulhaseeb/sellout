import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/personal/address/add_address/views/provider/add_address_provider.dart';
import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../widgets/shadow_container.dart';

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
    return ShadowContainer(
      onTap: onTap,
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
                        InkWell(
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'edit'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('${address.recipientName} . ${address.phoneNumber}'),
                    Text('${address.townCity} . ${address.postalCode}'),
                    Text(address.address),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
