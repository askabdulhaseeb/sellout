import '../../../../../core/widgets/rating_display_widget.dart';
import 'package:flutter/material.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';

class SearchServiceGridTile extends StatelessWidget {
  const SearchServiceGridTile({required this.service, super.key});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image
        SizedBox(
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              service.thumbnailURL ?? 'na',
              width: double.infinity,
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
    );
  }
}
