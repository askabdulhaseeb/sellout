import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../features/personal/address/add_address/views/screens/add_address_screen.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';

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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color borderColor =
        isSelected ? scheme.secondary : scheme.outlineVariant;
    final Color bgColor =
        isSelected ? scheme.secondary.withOpacity(0.05) : Colors.transparent;

    return AnimatedScale(
      scale: isSelected ? 1 : 0.95,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(isSelected ? 18 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            color: bgColor,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: scheme.secondary.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Radio button with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? scheme.secondary : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? scheme.secondary : Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isSelected
                      ? const Icon(Icons.circle,
                          key: ValueKey('dot'), color: Colors.white, size: 8)
                      : const SizedBox(key: ValueKey('empty')),
                ),
              ),
              const SizedBox(width: 12),
              // Address details
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder:
                                (Widget child, Animation<double> anim) =>
                                    FadeTransition(opacity: anim, child: child),
                            child: address.isDefault
                                ? Container(
                                    key: const ValueKey('defaultTag'),
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: scheme.secondary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'default'.tr().toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : const SizedBox(key: ValueKey('noDefault')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Address with home icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.home_outlined,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${address.address}, ${address.city},${address.country.displayName}, ${address.postalCode}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Phone with phone icon
                      Row(
                        children: <Widget>[
                          Icon(Icons.phone_outlined,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            address.phoneNumber.isNotEmpty
                                ? address.phoneNumber
                                : 'No phone',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Edit button animated
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: showButtons && isSelected
                    ? Container(
                        key: const ValueKey('editBtn'),
                        margin: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.of(context).push<AddressEntity?>(
                              MaterialPageRoute<AddressEntity?>(
                                builder: (BuildContext context) =>
                                    AddEditAddressScreen(initAddress: address),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: scheme.secondary),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'edit_address'.tr(),
                            style: TextStyle(
                              color: scheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(key: ValueKey('noEdit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
