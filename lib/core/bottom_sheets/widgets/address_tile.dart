import 'package:flutter/material.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    required this.address,
    required this.onTap,
    this.padding,
    super.key,
  });
  final AddressEntity address;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    address.category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${address.recipientName} . ${address.phoneNumber}'),
                  Text('${address.address} . ${address.country.countryName}'),
                  Text('${address.city} . ${address.postalCode}'),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 18,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
