import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../core/widgets/empty_page_widget.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/enums/review_sort_type.dart';
import '../params/review_list_param.dart';
import '../providers/review_provider.dart';
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
    Provider.of<ReviewProvider>(context, listen: false).init(widget.param);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reviews'.tr())),
      body: Consumer<ReviewProvider>(
        builder: (BuildContext context, ReviewProvider pro, _) {
          final List<ReviewEntity> reviews = pro.reviews();
          if (reviews.isEmpty) {
            return EmptyPageWidget(
              icon: CupertinoIcons.star_lefthalf_fill,
              childBelow: Text('no_reviews_found'.tr()),
            );
          }
          return Column(
            children: <Widget>[
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 140,
                      child: CustomDropdown<int>(
                        title: '',
                        items: <int>[1, 2, 3, 4, 5]
                            .map((int e) => DropdownMenuItem<int>(
                                value: e, child: Text('$e ${'star'.tr()}')))
                            .toList(),
                        selectedItem: pro.star,
                        onChanged: pro.setStar,
                        validator: (_) => '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 180,
                      child: CustomDropdown<ReviewSortType>(
                        title: '',
                        items: ReviewSortType.values
                            .map((ReviewSortType e) =>
                                DropdownMenuItem<ReviewSortType>(
                                  value: e,
                                  child: Text(e.code).tr(),
                                ))
                            .toList(),
                        selectedItem: pro.sortReview,
                        onChanged: pro.setSortReview,
                        validator: (_) => '',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: reviews.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ReviewTile(review: reviews[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
