import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import 'scaffold/bottom_bar/availability_time_dailog.dart';

class EditableAvailabilityWidget extends StatelessWidget {
  const EditableAvailabilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Text(
              'add_Availbility_for_viewing'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...provider.availability.map((AvailabilityEntity entity) {
              final bool isOpen = entity.isOpen;
              final bool hasValidTimes = entity.openingTime.isNotEmpty &&
                  entity.closingTime.isNotEmpty;
              final String timeRange = isOpen && hasValidTimes
                  ? '${entity.openingTime} - ${entity.closingTime}'
                  : 'Closed';

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Switch(
                          thumbIcon: WidgetStateProperty.all(Icon(
                            Icons.circle,
                            color: ColorScheme.of(context).surface,
                          )),
                          inactiveTrackColor: Theme.of(context).disabledColor,
                          activeTrackColor: ColorScheme.of(context).secondary,
                          thumbColor: WidgetStateProperty.all(
                              ColorScheme.of(context).surface),
                          trackOutlineColor: WidgetStateProperty.all(
                              ColorScheme.of(context).surface),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: isOpen,
                          onChanged: (bool val) {
                            provider.toggleOpen(entity.day, val);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          entity.day.name[0].toUpperCase() +
                              entity.day.name.substring(1),
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
