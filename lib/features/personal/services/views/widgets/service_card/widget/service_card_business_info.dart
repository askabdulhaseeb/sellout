import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';

class ServiceCardBusinessInfo extends StatelessWidget {
  const ServiceCardBusinessInfo({
    required this.business,
    required this.txt,
    required this.service,
    super.key,
  });

  final BusinessEntity business;
  final TextTheme txt;
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ProfilePhoto(
            url: business.logo?.url,
            placeholder: business.displayName ?? '',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(business.displayName ?? '', style: txt.titleMedium),
                  RatingDisplayWidget(
                    size: 12,
                    ratingList: service.listOfReviews,
                    displayStars: false,
                  ),
                ],
              ),
              Text(
                business.address?.firstAddress ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
