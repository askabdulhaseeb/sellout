import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../chats/chat/views/screens/chat_screen.dart';
import '../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../../user/profiles/data/sources/local/local_blocked_users.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/feed_response_params.dart';
import '../../../domain/params/get_feed_params.dart';
import '../../../domain/params/update_offer_params.dart';
import '../../../domain/usecase/create_offer_usecase.dart';
import '../../../domain/usecase/get_feed_usecase.dart';
import '../../../domain/usecase/update_offer_usecase.dart';

class FeedProvider extends ChangeNotifier {
  FeedProvider(
    this._getFeedUsecase,
    this._createOfferUsecase,
    this._getMyChatsUsecase,
    this._updateOfferUsecase,
  );

  // ——————————————————————————————
  // Dependencies
  // ——————————————————————————————
  final GetFeedUsecase _getFeedUsecase;
  final CreateOfferUsecase _createOfferUsecase;
  final UpdateOfferUsecase _updateOfferUsecase;
  final GetMyChatsUsecase _getMyChatsUsecase;

  // ——————————————————————————————
  // Feed Data and Pagination
  // ——————————————————————————————
  final ScrollController scrollController = ScrollController();
  List<PostEntity> _posts = <PostEntity>[];
  List<PostEntity> get posts => _posts;

  String? _nextPageToken;
  bool _noMorePosts = false;
  bool get noMorePosts => _noMorePosts;

  // ——————————————————————————————
  // Loading States
  // ——————————————————————————————
  bool _feedLoading = false;
  bool get feedLoading => _feedLoading;

  bool _feedLoadingMore = false;
  bool get feedLoadingMore => _feedLoadingMore;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ——————————————————————————————
  // Offer Amount
  // ——————————————————————————————
  String _offerAmount = '';
  String get offerAmount => _offerAmount;

  // ——————————————————————————————
  // Setters
  // ——————————————————————————————
  void setFeedLoading(bool value) {
    _feedLoading = value;
    notifyListeners();
  }

  void setFeedLoadingMore(bool value) {
    _feedLoadingMore = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearOfferAmount() {
    _offerAmount = '';
    notifyListeners();
  }

  /// Remove all posts from a blocked user from the feed
  void removeBlockedUserPosts(String userId) {
    final int initialCount = _posts.length;
    _posts.removeWhere((PostEntity post) => post.createdBy == userId);
    final int removedCount = initialCount - _posts.length;

    AppLog.info(
      'Removed $removedCount posts from blocked user: $userId',
      name: 'FeedProvider.removeBlockedUserPosts',
    );

    notifyListeners();
  }

  // ——————————————————————————————
  // FEED LOGIC
  // ——————————————————————————————

  /// Load first page of posts
  Future<void> loadInitialFeed(String type) async {
    AppLog.info(
      'Loading initial feed...',
      name: 'FeedProvider.loadInitialFeed',
    );
    setFeedLoading(true);
    _nextPageToken = null;
    _noMorePosts = false;
    _posts.clear();

    await _fetchFeed(type, _nextPageToken);

    setFeedLoading(false);
  }

  /// Load next page of posts (pagination)
  Future<void> loadMoreFeed(String type) async {
    if (_feedLoadingMore || _nextPageToken == null || _noMorePosts) return;

    AppLog.info('Loading more feed...', name: 'FeedProvider.loadMoreFeed');
    setFeedLoadingMore(true);

    await _fetchFeed(type, _nextPageToken);

    setFeedLoadingMore(false);
  }

  /// Refresh feed (pull-to-refresh)
  Future<void> refreshFeed(String type) async {
    AppLog.info('Refreshing feed...', name: 'FeedProvider.refreshFeed');
    _nextPageToken = null;
    _noMorePosts = false;
    _posts.clear();
    notifyListeners();

    await loadInitialFeed(type);
  }

  /// Internal fetch function for API call
  Future<void> _fetchFeed(String type, String? key) async {
    AppLog.info('Fetching feed started', name: 'FeedProvider._fetchFeed');
    try {
      final GetFeedParams params = GetFeedParams(type: type, key: key ?? '');
      final DataState<GetFeedResponse> result = await _getFeedUsecase(params);

      if (result is DataSuccess && result.entity != null) {
        AppLog.info(
          'Feed data success from API',
          name: 'FeedProvider._fetchFeed',
        );

        final List<PostEntity> fetchedPosts = result.entity!.posts;
        _nextPageToken = result.entity!.nextPageToken;

        final List<String> blockedUserIds = await LocalBlockedUsers()
            .getBlockedUsers();
        final List<PostEntity> filteredPosts = blockedUserIds.isEmpty
            ? fetchedPosts
            : fetchedPosts
                  .where(
                    (PostEntity post) =>
                        !blockedUserIds.contains(post.createdBy),
                  )
                  .toList();
        final int removedCount = fetchedPosts.length - filteredPosts.length;
        if (removedCount > 0) {
          AppLog.info(
            'Filtered $removedCount posts from blocked users',
            name: 'FeedProvider._fetchFeed',
          );
        }

        if (fetchedPosts.isEmpty) {
          _noMorePosts = true;
          AppLog.info(
            'No more posts available',
            name: 'FeedProvider._fetchFeed',
          );
        } else if (filteredPosts.isEmpty) {
          AppLog.info(
            'All fetched posts belong to blocked users; skipping append',
            name: 'FeedProvider._fetchFeed',
          );
        } else {
          // Merge + remove duplicates
          final Map<String, PostEntity> unique = <String, PostEntity>{
            for (final PostEntity p in <PostEntity>[
              ..._posts,
              ...filteredPosts,
            ])
              p.postID: p,
          };
          _posts = unique.values.toList();
          AppLog.info(
            'Total unique posts: ${_posts.length}',
            name: 'FeedProvider._fetchFeed',
          );
        }
      } else if (result is DataFailer) {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'FeedProvider._fetchFeed - DataFailer',
        );
      } else {
        AppLog.error(
          'Unknown feed fetch error',
          name: 'FeedProvider._fetchFeed',
        );
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'FeedProvider._fetchFeed - Exception');
    } finally {
      notifyListeners();
    }
  }

  // ——————————————————————————————
  // OFFER CREATION
  // ——————————————————————————————
  Future<DataState<bool>> createOffer({
    required BuildContext context,
    required String postId,
    required double offerAmount,
    required int quantity,
    required String listId,
    required String? size,
    required String? color,
  }) async {
    setIsLoading(true);
    final CreateOfferparams params = CreateOfferparams(
      postId: postId,
      offerAmount: offerAmount,
      currency: LocalAuth.currency,
      quantity: quantity,
      listId: listId,
      size: size,
      color: color,
    );

    try {
      final DataState<bool> result = await _createOfferUsecase.call(params);
      if (result is DataSuccess && result.data != null) {
        AppLog.info(
          'Offer created successfully',
          name: 'FeedProvider.createOffer',
        );

        final DataState<List<ChatEntity>> chatResult = await _getMyChatsUsecase
            .call(<String>[result.data!]);

        if (chatResult is DataSuccess && chatResult.entity!.isNotEmpty) {
          final ChatProvider chatProvider = Provider.of<ChatProvider>(
            context,
            listen: false,
          );
          chatProvider.setChat(context, chatResult.entity!.first);
          Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
          return result;
        } else if (chatResult is DataFailer) {
          AppLog.error(
            chatResult.exception?.message ?? 'something_wrong'.tr(),
            name: 'FeedProvider.createOffer - chatResult failed',
          );
        }
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'FeedProvider.createOffer - API failed',
        );
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'FeedProvider.createOffer - catch');
      return DataFailer<bool>(CustomException('$e'));
    } finally {
      setIsLoading(false);
    }
    return DataFailer<bool>(CustomException('something_wrong'.tr()));
  }

  // ——————————————————————————————
  // OFFER UPDATE
  // ——————————————————————————————
  Future<DataState<bool>> updateOffer({
    required BuildContext context,
    required String offerId,
    required String messageID,
    required String chatId,
    bool counterOffer = false,
    String? offerStatus,
    int? quantity,
    int? offerAmount,
    String size = '',
    String color = '',
    String currency = '',
  }) async {
    setIsLoading(true);

    final UpdateOfferParams params = UpdateOfferParams(
      currency: currency,
      counterOffer: counterOffer,
      chatID: chatId,
      offerAmount: offerAmount,
      offerStatus: offerStatus,
      quantity: quantity,
      messageId: messageID,
      offerId: offerId,
      size: size,
      color: color,
    );

    debugPrint(jsonEncode(params.toMap()));

    try {
      final DataState<bool> result = await _updateOfferUsecase.call(params);
      if (result is DataSuccess && result.data != null) {
        AppLog.info(
          'Offer updated successfully',
          name: 'FeedProvider.updateOffer',
        );
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'FeedProvider.updateOffer - API failed',
        );
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'FeedProvider.updateOffer - catch');
      return DataFailer<bool>(CustomException('$e'));
    } finally {
      setIsLoading(false);
    }

    return DataFailer<bool>(CustomException('something_wrong'.tr()));
  }
}
