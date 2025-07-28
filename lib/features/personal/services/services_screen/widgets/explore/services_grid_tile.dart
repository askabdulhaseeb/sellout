import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../service_detail/screens/service_detail_screen.dart';

class ServiceGridTile extends StatelessWidget {
  const ServiceGridTile({required this.service, super.key});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ServiceDetailScreen.routeName,
          arguments: <String, ServiceEntity>{'service': service}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image
          SizedBox(
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomNetworkImage(
                size: double.infinity,
                imageURL: service.thumbnailURL ?? 'na',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Name
          Text(
            service.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          // Review
          RatingDisplayWidget(
              fontSize: 10, size: 12, ratingList: service.listOfReviews)
          // Price
        ],
      ),
    );
  }
}
