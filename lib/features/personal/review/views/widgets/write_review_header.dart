import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/media/profile_photo.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post/post_entity.dart';

class WriteReviewHeaderSection extends StatelessWidget {
  const WriteReviewHeaderSection({
    required this.post,
    required this.service,
    super.key,
  });
  final PostEntity? post;
  final ServiceEntity? service;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150,
          width: 150,
          child: ProfilePhoto(
            url: post?.imageURL ?? service?.thumbnailURL,
            placeholder: post?.title ?? service?.name ?? 'na'.tr(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          textAlign: TextAlign.center,
          post?.title ?? service?.name ?? 'na',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        const Divider(),
      ],
    );
  }
}
