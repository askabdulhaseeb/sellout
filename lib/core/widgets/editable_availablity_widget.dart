import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../features/personal/location/domain/entities/location_entity.dart';
import '../../features/personal/location/domain/enums/map_display_mode.dart';
import '../../features/personal/location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import '../utilities/app_validators.dart';
import 'scaffold/bottom_bar/availability_time_dailog.dart';
import '../../core/enums/routine/day_type.dart';

class EditableAvailabilityWidget extends StatelessWidget {
  const EditableAvailabilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            NominationLocationField(
              validator: (bool? value) => AppValidator.requireLocation(value),
              title: 'meetup_location'.tr(),
              selectedLatLng: formPro.meetupLatLng,
              displayMode: MapDisplayMode.showMapAfterSelection,
              selectedLocation: formPro.selectedMeetupLocation,
              onLocationSelected: (LocationEntity p0, LatLng p1) =>
                  formPro.setMeetupLocation(p0, p1),
            ),
            Text(
              'add_availbility_for_viewing'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...DayType.values.map((DayType day) {
              final AvailabilityEntity entity = formPro.availability.firstWhere(
                (AvailabilityEntity e) => e.day == day,
                orElse: () {
                  return AvailabilityEntity(
                    day: day,
                    isOpen: false,
                    openingTime: '',
                    closingTime: '',
                  );
                },
              );
              final bool isOpen = entity.isOpen;
              final bool hasValidTimes = entity.openingTime.isNotEmpty &&
                  entity.closingTime.isNotEmpty;
              final String timeRange = isOpen && hasValidTimes
                  ? '${entity.openingTime} - ${entity.closingTime}'
                  : 'closed'.tr();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Switch(
                          value: isOpen,
                          onChanged: (bool val) {
                            formPro.toggleOpen(day, val);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          day.name[0].toUpperCase() + day.name.substring(1),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        isOpen
                            ? GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AvailabilityTimeDialog(entity: entity),
                                ),
                                child: Text(
                                  timeRange,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                ),
                              )
                            : Text(
                                timeRange,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant),
                              ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant)
                      ],
                    ),
                    const Divider()
                  ],
                ),
              );
            })
          ],
        );
      },
    );
  }
}
