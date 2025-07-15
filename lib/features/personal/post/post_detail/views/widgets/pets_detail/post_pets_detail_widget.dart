import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/post_entity.dart';

class PostPetDetailWidget extends StatelessWidget {
  const PostPetDetailWidget({super.key, required this.post});
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
              _detailItem('age'.tr(), post.age ?? 'na'.tr()),
              _detailItem('breed'.tr(), post.breed ?? 'na'.tr()),
              _detailItem(
                'vaccination_up_to_date'.tr(),
                _boolToYesNo(post.vaccinationUpToDate),
              ),
              _detailItem(
                  'ready_to_leave'.tr(), post.readyToLeave ?? 'na'.tr()),
              _detailItem(
                'health_checked'.tr(),
                _boolToYesNo(post.healthChecked),
              ),
              _detailItem(
                'worm_flee_treated'.tr(),
                _boolToYesNo(post.wormAndFleaTreated),
              ),
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
      children: [
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
