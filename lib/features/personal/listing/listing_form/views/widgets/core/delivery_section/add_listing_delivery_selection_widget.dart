import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../providers/add_listing_form_provider.dart';
import 'widgets/delivery_charges_widget.dart';
import 'widgets/delivery_collection_location_widget.dart';
import 'widgets/delivery_options_row.dart';

/// Widget for selecting delivery options in the listing form
class AddListingDeliverySelectionWidget extends StatelessWidget {
  const AddListingDeliverySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          spacing: AppSpacing.vXs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DeliveryOptionsRow(
              selectedType: formPro.deliveryType,
              onDeliveryTypeSelected: formPro.setDeliveryType,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: formPro.deliveryType == DeliveryType.collection
                  ? const DeliveryCollectionLocationWidget()
                  : const DeliveryChargesWidget(),
            ),
          ],
        );
      },
    );
  }
}
