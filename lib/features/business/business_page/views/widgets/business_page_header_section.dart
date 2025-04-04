import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/rating_display_widget.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
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
    final bool isMe = LocalAuth.currentUser?.businessID == business.businessID;
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    child: Text(
                      business.address?.firstAddress ?? '',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
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
            Column(
              children: <Widget>[
                CustomElevatedButton(
                  padding: const EdgeInsets.all(6),
                  onTap: () {},
                  isLoading: false,
                  title: 'edit'.tr(),
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                  bgColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
