import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class RatingSelectWidget extends StatelessWidget {
  const RatingSelectWidget({
    this.maxRating = 5,
    this.size = 24,
    super.key,
  });

  final int maxRating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              maxRating,
              (int index) {
                final double fullStarThreshold = index + 1.0;
                final bool isFilled =
                    reviewProvider.rating >= fullStarThreshold;
                final bool isHalf = reviewProvider.rating > index &&
                    reviewProvider.rating < fullStarThreshold;

                return GestureDetector(
                  onTapDown: (details) {
                    final position = details.localPosition.dx;
                    final starWidth = size;
                    double newRating;

                    if (position < starWidth / 2) {
                      newRating = index + 0.5;
                    } else {
                      newRating = index + 1.0;
                    }

                    reviewProvider.updateRating(newRating);
                  },
                  child: Icon(
                    isFilled
                        ? Icons.star
                        : isHalf
                            ? Icons.star_half
                            : Icons.star_border,
                    size: size,
                    color: (isFilled || isHalf)
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
