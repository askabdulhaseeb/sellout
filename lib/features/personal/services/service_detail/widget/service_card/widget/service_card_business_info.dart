import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../../business/business_page/views/screens/business_profile_screen.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';

class ServiceCardBusinessInfo extends StatelessWidget {
  const ServiceCardBusinessInfo({
    required this.business,
    required this.txt,
    required this.service,
    super.key,
  });

  final BusinessEntity? business;
  final TextTheme txt;
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute<BusinessProfileScreen>(
              builder: (BuildContext context) => BusinessProfileScreen(
                  businessID: business?.businessID ?? ''))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ProfilePhoto(
              url: business?.logo?.url,
              placeholder: business?.displayName ?? 'na'.tr(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  spacing: 4,
                  children: <Widget>[
                    Text(business?.displayName ?? 'na'.tr(),
                        style: txt.titleMedium),
                    RatingDisplayWidget(
                      size: 12,
                      ratingList: service.listOfReviews,
                      displayStars: false,
                    ),
                  ],
                ),
                Text(
                  business?.address?.firstAddress ?? 'na'.tr(),
                  overflow: TextOverflow.ellipsis,
                  style: TextTheme.of(context).bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
