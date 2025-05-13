import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../domain/enums/review_sort_type.dart';
import '../../../../domain/param/create_review_params.dart';
import '../../../../domain/usecase/create_review_usecase.dart';
import '../../../../domain/entities/review_entity.dart';
import '../params/review_list_param.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewProvider(this.createReviewUsecase);
  final CreateReviewUsecase createReviewUsecase;
  List<ReviewEntity> _reviews = <ReviewEntity>[];
  TextEditingController reviewTitle = TextEditingController();
  TextEditingController reviewdescription = TextEditingController();
  String postIdentity = '';
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  int _currentIndex = 0;
  VideoPlayerController? _videoController;
  bool _isloading = false;
  List<PickedAttachment> get attachments => _attachments;
  int get currentIndex => _currentIndex;
  VideoPlayerController? get videoController => _videoController;
  bool get isloading => _isloading;
  init(ReviewListScreenParam param) {
    _reviews = param.reviews;
    _sortType = param.sortType ?? ReviewSortType.topReview;
    _star = param.star;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  set isloading(bool value) {
    _isloading = value;
    notifyListeners();
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

  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment> selectedMedia =
        _attachments.where((PickedAttachment element) {
      return element.selectedMedia != null;
    }).toList();
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 10,
            allowMultiple: true,
            type: type,
            selectedMedia: selectedMedia
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        );
      }),
    );
    if (files != null) {
      for (final PickedAttachment file in files) {
        final int index = _attachments.indexWhere((PickedAttachment element) =>
            element.selectedMedia == file.selectedMedia);
        if (index == -1) {
          _attachments.add(file);
        }
      }
      notifyListeners();
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);

    // Adjust currentIndex to avoid out-of-range errors
    if (currentIndex >= attachments.length) {
      _currentIndex = attachments.isEmpty ? 0 : attachments.length - 1;
    }

    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  double _rating = 1.0; // Minimum rating is 1.0

  double get rating => _rating;

  void updateRating(double newRating) {
    _rating = newRating < 1.0 ? 1.0 : newRating; // Ensure minimum rating is 1
    notifyListeners(); // Notify UI to update
  }

  void updatePostidentity(postId) {
    postIdentity = postId;
    debugPrint('this is the post id $postId');
  }

  Future<void> submitReview(context) async {
    _isloading = true;
    final CreateReviewParams params = CreateReviewParams(
        postId: postIdentity,
        rating: rating.toString(),
        title: reviewTitle.text,
        text: reviewdescription.text,
        reviewType: 'post',
        attachments: attachments);
    final DataState<bool> result = await createReviewUsecase(params);
    if (result is DataSuccess<bool>) {
      debugPrint('${result.data},${result.entity}');
      Navigator.pop(context);
      isloading = false;
    } else {
      AppLog.error('something_wrong'.tr(),
          name: 'ReiewProvider.submitreview - else');
    }
    isloading = false;
  }

  void disposed() {
    updateRating(1);
    reviewTitle.clear();
    reviewdescription.clear();
    _videoController?.dispose();
    _attachments.clear();
    attachments.clear();
  }
}
