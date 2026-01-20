import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/add_listing_form_provider.dart';
import '../enums/delivery_payer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import 'package_detail_card/package_details_card.dart';

class DeliveryChargesWidget extends StatelessWidget {
  const DeliveryChargesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.vMd,
          children: <Widget>[
            DeliveryPayerToggle(
              selectedPayer: formPro.deliveryPayer,
              onPayerChanged: (DeliveryPayer value) =>
                  formPro.setDeliveryPayer(value),
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
    return Column(
      children: <Widget>[
        CustomToggleSwitch<DeliveryPayer>(bgColor: ColorScheme.of(context).outlineVariant,
          verticalMargin: 4,
          horizontalMargin: 4,
          initialValue: selectedPayer,
          isShaded: false,
          solidbgColor: true,
          selectedColors: <Color>[
            Theme.of(context).colorScheme.primaryContainer,
          ],
          unseletedBorderColor: Colors.transparent,
          labels: const <DeliveryPayer>[
            DeliveryPayer.buyerPays,
            DeliveryPayer.sellerPays,
          ],
          labelStrs: DeliveryPayer.values
              .map((DeliveryPayer e) => e.code.tr())
              .toList(),
          labelText: 'who_pays'.tr(),
          onToggle: onPayerChanged,
        ),
      ],
    );
  }
}
