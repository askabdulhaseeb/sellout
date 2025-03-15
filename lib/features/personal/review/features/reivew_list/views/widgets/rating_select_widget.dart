import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class RatingSelectWidget extends StatefulWidget {
  const RatingSelectWidget({
    required this.initialRating,
    this.maxRating = 5,
    this.size = 24,
    this.onRatingChanged,
    super.key,
  });

  final int maxRating;
  final double size;
  final double initialRating;
  final ValueChanged<double>? onRatingChanged;

  @override
  RatingSelectWidgetState createState() => RatingSelectWidgetState();
}

class RatingSelectWidgetState extends State<RatingSelectWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating; // Initialize the rating
  }

  void _updateRating(double rating) {
    setState(() {
      _rating = rating; // Update local rating state
    });

    // Update the provider's rating
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.updateRating(rating);

    // Notify parent widget of rating change
    if (widget.onRatingChanged != null) {
      widget.onRatingChanged!(rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          widget.maxRating,
          (int index) {
            // Calculate if the star is filled, half-filled, or unfilled
            final double fullStarThreshold = index + 1.0;
            final bool isFilled = _rating >= fullStarThreshold;
            final bool isHalf = _rating > index && _rating < fullStarThreshold;

            return GestureDetector(
              onTapDown: (details) {
                // Get the position of the tap within the star's bounds
                final position = details.localPosition.dx;
                final starWidth = widget.size;

                // Check if the tap is on the left or right half of the star
                if (position < starWidth / 2) {
                  _updateRating(index + 0.5); // Half-filled star
                } else {
                  _updateRating(index + 1.0); // Fully filled star
                }
              },
              child: Icon(
                isFilled
                    ? Icons.star
                    : isHalf
                        ? Icons.star_half
                        : Icons.star_border,
                size: widget.size,
                color: isFilled ? Theme.of(context).primaryColor : Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
