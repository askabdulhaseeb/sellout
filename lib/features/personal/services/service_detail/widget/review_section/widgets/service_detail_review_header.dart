import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/indicators/rating_display_widget.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';

class ServiceDetailReviewHeader extends StatelessWidget {
  const ServiceDetailReviewHeader({required this.service, super.key});

  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'customer_reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 2),
        Row(
          children: <Widget>[
            RatingDisplayWidget(
              ratingList: service.listOfReviews,
              displayPrefix: false,
              displayRating: false,
            ),
            const SizedBox(width: 4),
            RatingDisplayWidget(
              ratingList: service.listOfReviews,
              displayStars: false,
              displayPrefix: false,
            ),
            Text('out_of_5'.tr()),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
