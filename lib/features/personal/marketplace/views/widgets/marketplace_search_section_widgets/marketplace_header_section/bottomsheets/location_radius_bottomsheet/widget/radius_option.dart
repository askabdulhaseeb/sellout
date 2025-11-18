import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../domain/enum/radius_type.dart';

class RadiusOptions extends StatelessWidget {
  const RadiusOptions({
    required this.radiusType,
    required this.onChanged,
    super.key,
  });

  final RadiusType radiusType;
  final ValueChanged<RadiusType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('worldwide_radius'.tr(),
                    style: const TextStyle(fontSize: 12)),
                Text('Show_listings_anywhere'.tr(),
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
            Radio<RadiusType>(
              fillColor:
                  WidgetStateProperty.all(Theme.of(context).primaryColor),
              value: RadiusType.worldwide,
              groupValue: radiusType,
              onChanged: (RadiusType? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('local_radius'.tr(), style: const TextStyle(fontSize: 12)),
                Text('Show_specific_listings'.tr(),
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
            Radio<RadiusType>(
              fillColor:
                  WidgetStateProperty.all(Theme.of(context).primaryColor),
              value: RadiusType.local,
              groupValue: radiusType,
              onChanged: (RadiusType? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
