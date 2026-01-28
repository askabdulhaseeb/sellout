import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../widgets/buttons/custom_elevated_button.dart';

class SelectableAddressTile extends StatelessWidget {
  const SelectableAddressTile({
    required this.address,
    required this.onTap,
    this.onSelect,
    this.padding,
    this.isSelected = false,
    this.showButtons = true,
    super.key,
  });

  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onSelect;
  final EdgeInsetsGeometry? padding;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : ColorScheme.of(context).outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey,
                  width: 2,
                ),
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, color: Colors.white, size: 8)
                  : null,
            ),
            const SizedBox(width: 12),
            // Address details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Name with default tag
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          address.recipientName.isNotEmpty
                              ? address.recipientName
                              : 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Address with home icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${address.address1}, ${address.city},${address.country.displayName}, ${address.postalCode}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Phone with phone icon
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          address.phoneNumber.isNotEmpty
                              ? address.phoneNumber
                              : 'No phone',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Edit button
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: <Widget>[
                if (showButtons && isSelected)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: CustomElevatedButton(
                      padding: const EdgeInsets.all(4),
                      onTap: () async {
                        Navigator.of(context).push<AddressEntity?>(
                          MaterialPageRoute<AddressEntity?>(
                            builder: (BuildContext context) {
                              return AddEditAddressScreen(initAddress: address);
                            },
                          ),
                        );
                      },
                      border: Border.all(
                        color: ColorScheme.of(context).secondary,
                      ),
                      bgColor: Colors.transparent,
                      isLoading: false,
                      title: 'edit_address'.tr(),
                      textStyle: TextTheme.of(context).bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                if (address.isDefault) ...<Widget>[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'default'.tr().toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
