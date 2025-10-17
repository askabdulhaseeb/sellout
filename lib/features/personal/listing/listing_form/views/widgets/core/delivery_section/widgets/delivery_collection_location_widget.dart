import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../../providers/add_listing_form_provider.dart';

class DeliveryCollectionLocationWidget extends StatelessWidget {
  const DeliveryCollectionLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.hSm,
            vertical: AppSpacing.vXs,
          ),
          child: NominationLocationField(
            hint: 'collection_location'.tr(),
            validator: (bool? value) => AppValidator.requireLocation(value),
            selectedLatLng: formPro.collectionLatLng,
            displayMode: MapDisplayMode.showMapAfterSelection,
            initialText: formPro.selectedCollectionLocation?.address ?? '',
            onLocationSelected: (LocationEntity location, LatLng latLng) {
              formPro.setCollectionLocation(location, latLng);
            },
          ),
        );
      },
    );
  }
}
