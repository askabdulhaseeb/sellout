import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../domain/entities/review_entity.dart';
import '../params/review_list_param.dart';
import '../providers/review_list_provider.dart';
import '../widgets/review_tile.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({required this.param, super.key});
  final ReviewListScreenParam param;

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  void initState() {
    Provider.of<ReviewListProvider>(context, listen: false).init(widget.param);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reviews'.tr())),
      body: Consumer<ReviewListProvider>(
        builder: (BuildContext context, ReviewListProvider provider, _) {
          final List<ReviewEntity> reviews = provider.reviews();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int index) {
                return ReviewTile(review: reviews[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
