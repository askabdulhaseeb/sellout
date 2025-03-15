import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../services/get_it.dart';
import '../../providers/explore_provider.dart';

class RatingFilterDialog extends StatefulWidget {
  const RatingFilterDialog({super.key});

  @override
  State<RatingFilterDialog> createState() => _RatingFilterDialogState();
}

class _RatingFilterDialogState extends State<RatingFilterDialog> {
  ExploreProvider pro = ExploreProvider(locator(),locator());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (int index) {
          int rating = index + 1;
          return ListTile(
            title: Text("$rating Stars"),
            onTap: () {
              pro.setRating(rating);
              Navigator.pop(context);
            },
          );
        }),
      ),
    );
  }
}
