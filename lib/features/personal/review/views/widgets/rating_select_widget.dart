import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class RatingSelectWidget extends StatelessWidget {
  const RatingSelectWidget({
    this.size = 24,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder:
          (BuildContext context, ReviewProvider reviewProvider, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              5,
              (int index) {
                final double fullStarThreshold = index + 1.0;
                final bool isFilled =
                    reviewProvider.rating >= fullStarThreshold;
                final bool isHalf = reviewProvider.rating > index &&
                    reviewProvider.rating < fullStarThreshold;

                return GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    final double position = details.localPosition.dx;
                    final double starWidth = size;
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
