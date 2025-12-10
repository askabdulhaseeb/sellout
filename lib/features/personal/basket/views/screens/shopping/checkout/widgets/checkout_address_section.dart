import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';

class SimpleCheckoutAddressSection extends StatefulWidget {
  const SimpleCheckoutAddressSection({super.key});

  @override
  State<SimpleCheckoutAddressSection> createState() =>
      SimpleCheckoutAddressSectionState();
}

class SimpleCheckoutAddressSectionState
    extends State<SimpleCheckoutAddressSection> {
  bool _isLoading = false;

  /// Formats the address details, handling empty state gracefully.
  String _formatAddressDetails(AddressEntity address) {
    final String city = address.city;
    final String state = address.state.stateName;
    final String country = address.country.displayName;
    final String postalCode = address.postalCode;

    // Build the first line: city, state (skip empty values)
    final List<String> line1Parts = <String>[
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
    ];
    final String line1 = line1Parts.join(', ');

    // Build the second line: country postalCode
    final List<String> line2Parts = <String>[
      if (country.isNotEmpty) country,
      if (postalCode.isNotEmpty) postalCode,
    ];
    final String line2 = line2Parts.join(' ');

    if (line1.isEmpty && line2.isEmpty) {
      return '';
    }
    if (line1.isEmpty) {
      return line2;
    }
    if (line2.isEmpty) {
      return line1;
    }
    return '$line1\n$line2';
  }

  Future<void> _onAddressTap(CartProvider cartPro) async {
    final AddressEntity? newAddress = await showModalBottomSheet<AddressEntity>(
      context: context,
      builder: (_) => AddressBottomSheet(initAddress: cartPro.address),
    );

    if (newAddress != null) {
      setState(() => _isLoading = true);
      cartPro.setAddress(newAddress);
      await cartPro.getRates();
      setState(() => _isLoading = false);

      if (mounted && cartPro.postageResponseEntity != null) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const PostageBottomSheet(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, CartProvider cartPro, __) {
        // Set default address if not set and available in LocalAuth
        if (cartPro.address == null &&
            LocalAuth.currentUser?.address != null &&
            LocalAuth.currentUser!.address.isNotEmpty) {
          AddressEntity? defaultAddress;
          for (final AddressEntity addr in LocalAuth.currentUser!.address) {
            if (addr.isDefault) {
              defaultAddress = addr;
              break;
            }
          }
          defaultAddress ??= LocalAuth.currentUser!.address[0];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && cartPro.address == null) {
              cartPro.setAddress(defaultAddress!);
            }
          });
        }
        return InkWell(
          onTap: () => _onAddressTap(cartPro),
          borderRadius: BorderRadius.circular(8),
          child: ShadowContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${'post_to'.tr()}:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      Text(cartPro.address?.address1 ?? 'no_address'.tr(),
                          style: const TextStyle(fontSize: 13, height: 1.4)),
                      if (cartPro.address != null)
                        Text(
                          _formatAddressDetails(cartPro.address!),
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        );
      },
    );
  }
}
