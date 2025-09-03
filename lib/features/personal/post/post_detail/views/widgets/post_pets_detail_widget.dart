import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/post/post_entity.dart';

class PostPetDetailWidget extends StatelessWidget {
  const PostPetDetailWidget({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // optional: adds spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _detailItem('age'.tr(), post.petInfo?.age ?? 'na'.tr()),
          _detailItem('breed'.tr(), post.petInfo?.breed ?? 'na'.tr()),
          _detailItem(
            'vaccination_up_to_date'.tr(),
            _boolToYesNo(post.petInfo?.vaccinationUpToDate),
          ),
          _detailItem(
              'ready_to_leave'.tr(), post.petInfo?.readyToLeave ?? 'na'.tr()),
          _detailItem(
            'health_checked'.tr(),
            _boolToYesNo(post.petInfo?.healthChecked),
          ),
          _detailItem(
            'worm_flee_treated'.tr(),
            _boolToYesNo(post.petInfo?.wormAndFleaTreated),
          ),
        ],
      ),
    );
  }

  String _boolToYesNo(bool? value) {
    if (value == true) return 'yes'.tr();
    if (value == false) return 'no'.tr();
    return 'na'.tr();
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
