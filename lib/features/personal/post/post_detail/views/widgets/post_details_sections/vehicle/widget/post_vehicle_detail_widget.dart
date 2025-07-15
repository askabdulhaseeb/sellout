import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../domain/entities/post_entity.dart';

class PostVehicleDetailWidget extends StatelessWidget {
  const PostVehicleDetailWidget({super.key, required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _detailItem('fuel_type'.tr(), post.fuelType ?? 'na'.tr()),
              _detailItem('body_type'.tr(), post.bodyType ?? 'na'.tr()),
              _detailItem(
                'engine'.tr(),
                _boolToYesNo(post.vaccinationUpToDate),
              ),
              // _detailItem('gearbox'.tr(), post.address ?? 'na'.tr()),
              _detailItem('milage'.tr(), post.mileage.toString()),
              _detailItem('doors'.tr(), post.doors.toString()),
              _detailItem('seats'.tr(), post.seats.toString()),
              _detailItem('emission'.tr(), post.emission ?? 'na'.tr()),
            ],
          ),
        ),
      ],
    );
  }

  String _boolToYesNo(bool? value) {
    if (value == true) return 'yes'.tr();
    if (value == false) return 'no'.tr();
    return 'na'.tr(); // In case it's null
  }

  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
