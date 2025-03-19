import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../data/sources/local_review.dart';
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
  final List<PickedAttachment> _selectedattachment = <PickedAttachment>[];
  int _currentIndex = 0;
  VideoPlayerController? _videoController;
  bool _isloading = false;
  List<PickedAttachment> get attachments => _attachments;
  List<PickedAttachment> get selectedattachment => _selectedattachment;
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

  Future<void> fetchMedia() async {
    final previousSelection = _selectedattachment.toList();
    _attachments.clear();
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return;
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image | RequestType.video,
    );

    if (albums.isNotEmpty) {
      final List<AssetEntity> mediaAssets =
          await albums.first.getAssetListPaged(page: 0, size: 50);

      for (final AssetEntity asset in mediaAssets) {
        final file = await asset.file;
        if (file != null) {
          final newAttachment = PickedAttachment(
            type: asset.type == AssetType.video
                ? AttachmentType.video
                : AttachmentType.image,
            selectedMedia: asset,
            file: file,
          );

          _attachments.add(newAttachment);

          // Restore selection if the media was previously selected
          if (previousSelection.any((a) => a.file.path == file.path)) {
            _selectedattachment.add(newAttachment);
          }
        }
      }
    }
    notifyListeners();
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

  void toggleMediaSelection(PickedAttachment asset) {
    int index =
        _selectedattachment.indexWhere((a) => a.file.path == asset.file.path);
    if (index != -1) {
      _selectedattachment.removeAt(index);
    } else {
      _selectedattachment.add(asset);
    }
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void clearSelection() {
    _selectedattachment.clear();
    notifyListeners();
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

  Future<void> submitReview(context) async {
    _isloading = true;
    final params = CreateReviewParams(
        postId: postIdentity,
        rating: rating.toString(),
        title: reviewTitle.text,
        text: reviewdescription.text,
        reviewType: 'post',
        attachments: selectedattachment);
    final DataState<bool> result = await createReviewUsecase(params);
    if (result is DataSuccess<bool>) {
      debugPrint('${result.data},${result.entity}');
      Navigator.pop(context);
    } else {
      AppLog.error('something_wrong'.tr(),
          name: 'ReiewProvider.submitreview - else');
    }
    isloading = false;
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
