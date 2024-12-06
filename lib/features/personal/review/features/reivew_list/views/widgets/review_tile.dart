import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../domain/entities/review_entity.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({required this.review, super.key});
  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity?>(
      future: LocalUser().user(review.reviewBy),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        final UserEntity? user = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ProfilePhoto(
                    url: user?.profilePhotoURL,
                    placeholder: user?.displayName ?? '',
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      user?.displayName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              //
              const SizedBox(height: 6),
              RatingDisplayWidget(
                ratingList: <double>[review.rating],
                displayPrefix: false,
              ),
              Text('${'review-on'.tr()} ${review.createdAt.dateWithFullMonth}'),
              const SizedBox(height: 6),
              Text(
                review.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(review.text),
              if (review.fileUrls.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: review.fileUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomNetworkImage(
                              imageURL: review.fileUrls[index].url,
                              size: 80,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
