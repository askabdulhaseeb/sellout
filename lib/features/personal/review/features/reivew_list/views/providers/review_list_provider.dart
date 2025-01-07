import 'package:flutter/material.dart';

import '../../../../domain/entities/review_entity.dart';
import '../../domain/enums/review_sort_type.dart';
import '../params/review_list_param.dart';

class ReviewListProvider extends ChangeNotifier {
  List<ReviewEntity> _reviews = <ReviewEntity>[];

  init(ReviewListScreenParam param) {
    _reviews = param.reviews;
    _sortType = param.sortType ?? ReviewSortType.topReview;
    _star = param.star;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setReviews(List<ReviewEntity> reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  ReviewSortType _sortType = ReviewSortType.topReview;
  ReviewSortType get sortReview => _sortType;
  void setSortReview(ReviewSortType? value) {
    _sortType = value ?? ReviewSortType.topReview;
    notifyListeners();
  }

  int? _star;
  int? get star => _star;
  void setStar(int? value) {
    _star = value;
    notifyListeners();
  }

  List<ReviewEntity> reviews() {
    List<ReviewEntity> fake = <ReviewEntity>[];
    if (_star != null) {
      for (ReviewEntity element in _reviews) {
        if (element.rating.ceil() == _star) {
          fake.add(element);
        }
      }
    } else {
      fake.addAll(_reviews);
    }
    if (_sortType == ReviewSortType.topReview) {
      fake.sort(
          (ReviewEntity a, ReviewEntity b) => a.rating.compareTo(b.rating));
    } else {
      fake.sort((ReviewEntity a, ReviewEntity b) =>
          b.createdAt.compareTo(a.createdAt));
    }
    return fake;
  }

  void clearFilters() {
    _sortType = ReviewSortType.topReview;
    _star = null;
    notifyListeners();
  }
}
