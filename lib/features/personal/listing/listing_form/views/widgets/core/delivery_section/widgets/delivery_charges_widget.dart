import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/add_listing_form_provider.dart';
import '../enums/delivery_payer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../../../../../core/widgets/shadow_container.dart';
import 'package_details_card.dart';

class DeliveryChargesWidget extends StatelessWidget {
  const DeliveryChargesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            DeliveryPayerToggle(
              selectedPayer: formPro.deliveryPayer,
              onPayerChanged: formPro.setDeliveryPayer,
            ),
            const PackageDetailsCard(),
          ],
        );
      },
    );
  }
}

class DeliveryPayerToggle extends StatelessWidget {
  const DeliveryPayerToggle({
    required this.selectedPayer,
    required this.onPayerChanged,
    super.key,
  });

  final DeliveryPayer selectedPayer;
  final ValueChanged<DeliveryPayer> onPayerChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ShadowContainer(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.vXs),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: CustomToggleSwitch<DeliveryPayer>(
        solidbgColor: true,
        initialValue: selectedPayer,
        isShaded: false,
        unseletedBorderColor: Colors.transparent,
        unseletedTextColor: colorScheme.outline,
        labels: const <DeliveryPayer>[
          DeliveryPayer.buyerPays,
          DeliveryPayer.sellerPays,
        ],
        labelStrs:
            DeliveryPayer.values.map((DeliveryPayer e) => e.code.tr()).toList(),
        labelText: '',
        onToggle: onPayerChanged,
      ),
    );
  }
}
