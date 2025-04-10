import 'package:flutter/material.dart';

class RatingDisplayWidget extends StatelessWidget {
  const RatingDisplayWidget({
    required this.ratingList,
    this.displayPrefix = true,
    this.displayStars = true,
    this.displayRating = true,
    this.maxRating = 5,
    this.size = 16,
    this.onTap,
    super.key,
  });
  final int maxRating;
  final double size;
  final List<double> ratingList;
  final bool displayPrefix;
  final bool displayStars;
  final bool displayRating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double rating = ratingList.isEmpty
        ? 0
        : ratingList.reduce((double a, double b) => a + b) / ratingList.length;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (displayRating)
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Text(
                rating.toStringAsFixed(1),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          if (displayPrefix)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '(${ratingList.length})',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          if (displayStars)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                maxRating,
                (int index) {
                  final bool isFilled = index < rating;
                  final bool isHalf = index == rating.floor();
                  final bool isHalfStar = rating % 1 != 0 && isHalf;
                  return Icon(
                    isFilled && !isHalf
                        ? Icons.star
                        : isHalfStar
                            ? Icons.star_half
                            : Icons.star_border,
                    size: size,
                    color:
                        isFilled ? Theme.of(context).primaryColor : Colors.grey,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
