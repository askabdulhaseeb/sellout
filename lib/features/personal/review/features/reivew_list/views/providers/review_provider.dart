import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../../core/sources/data_state.dart';
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
  List<AssetEntity> _assets = <AssetEntity>[];
  final List<AssetEntity> _selectedMedia = <AssetEntity>[];
  int _currentIndex = 0;
  VideoPlayerController? _videoController;

  List<AssetEntity> get assets => _assets;
  List<AssetEntity> get selectedMedia => _selectedMedia;
  int get currentIndex => _currentIndex;
  VideoPlayerController? get videoController => _videoController;
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

  Future<void> fetchMedia() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.common,
      );

      if (albums.isNotEmpty) {
        _assets = await albums.first.getAssetListPaged(page: 0, size: 50);
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  /// Load video and play
  Future<void> loadVideo(AssetEntity asset) async {
    if (asset.type == AssetType.video) {
      final File? file = await asset.file;
      if (file != null) {
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            _videoController!.play();
          });
      }
    }
  }

  /// Toggle selection of an image or video
  void toggleMediaSelection(AssetEntity asset) {
    if (_selectedMedia.contains(asset)) {
      _selectedMedia.remove(asset);
    } else {
      _selectedMedia.add(asset);
    }
    notifyListeners();
  }

  /// Set the current preview index
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Clear all selected media
  void clearSelection() {
    _selectedMedia.clear();
  }

  double _rating = 0.0;

  double get rating => _rating;

  void updateRating(double newRating) {
    _rating = newRating;
  }

  void updatePostidentity(postId) {
    postIdentity = postId;
    debugPrint('this is the post id $postId');
  }

  Future<void> submitReview() async {
    final params = CreateReviewParams(
      postId: postIdentity,
      rating: rating,
      title: reviewTitle.text,
      text: reviewdescription.text,
      reviewType: 'post',

    );
    final result = await createReviewUsecase(params);
    debugPrint('postId${params.postId},Rating${params.rating}');
    debugPrint('Title: ${reviewTitle.text}');
    debugPrint('Review: ${reviewdescription.text}');
    if (result is DataSuccess<bool>) {
      debugPrint(' Review posted successfully');
    } else {
      debugPrint(' Error');
    }
  }

  /// Dispose controllers properly
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
