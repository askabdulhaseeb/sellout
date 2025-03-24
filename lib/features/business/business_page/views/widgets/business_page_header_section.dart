import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/rating_display_widget.dart';
import '../../../../personal/review/domain/entities/review_entity.dart';
import '../../../../personal/review/features/reivew_list/views/params/review_list_param.dart';
import '../../../../personal/review/features/reivew_list/views/screens/review_list_screen.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../providers/business_page_provider.dart';

class BusinessPageHeaderSection extends StatelessWidget {
  const BusinessPageHeaderSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CustomNetworkImage(
                  size: double.infinity,
                  imageURL: business.logo?.url,
                  placeholder: business.displayName ?? '',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    business.displayName ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text(business.location!.address, maxLines: 2),
                  ),
                  const SizedBox(height: 8),
                  RatingDisplayWidget(
                    ratingList: business.listOfReviews ?? <double>[],
                    onTap: () async {
                      final List<ReviewEntity> reviews =
                          await Provider.of<BusinessPageProvider>(context,
                                  listen: false)
                              .getReviews(business.businessID);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute<ReviewListScreenParam>(
                          builder: (BuildContext context) => ReviewListScreen(
                            param: ReviewListScreenParam(reviews: reviews),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
