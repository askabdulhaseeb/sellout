import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../chats/chat/views/screens/chat_screen.dart';
import '../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../domain/entities/post_entity.dart';
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
  final GetFeedUsecase _getFeedUsecase;
  final CreateOfferUsecase _createOfferUsecase;
  final UpdateOfferUsecase _updateOfferUsecase;
  final GetMyChatsUsecase _getMyChatsUsecase;
  // final UpdateOfferStatusUsecase _updateOfferStatusUsecase;

  String _offerAmount = '';
  String get offerAmount => _offerAmount;
  String? _nextPageToken;
  final ScrollController scrollController = ScrollController();
  List<PostEntity> get posts => _posts;
  List<PostEntity> _posts = <PostEntity>[];
//
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

//
  bool _feedLoading = true;
  bool get feedLoading => _feedLoading;
  void setFeedLoading(bool value) {
    _feedLoading = value;
    notifyListeners();
  }

  void clearOfferAmount() {
    _offerAmount = '';
    notifyListeners();
  }

  Future<void> loadInitialFeed(String type) async {
    setFeedLoading(true);
    _nextPageToken = null;
    _posts = <PostEntity>[];
    await _fetchFeed(type, _nextPageToken);
    setFeedLoading(false);
  }

  Future<void> loadMoreFeed(String type) async {
    if (_isLoading || _nextPageToken == null) return;
    setFeedLoading(true);
    try {
      await _fetchFeed(type, _nextPageToken);
    } finally {
      setFeedLoading(false);
    }
  }

  Future<void> _fetchFeed(String type, String? key) async {
    AppLog.info('Fetching feed started', name: 'FeedProvider._fetchFeed');

    final GetFeedParams params = GetFeedParams(type: type, key: key ?? '');
    final DataState<GetFeedResponse> result = await _getFeedUsecase(params);

    if (result is DataSuccess && result.entity != null) {
      AppLog.info('Feed data success from API',
          name: 'FeedProvider._fetchFeed');

      final List<PostEntity> fetchedPosts = result.entity!.posts;
      _nextPageToken = result.entity!.nextPageToken;
      // Merge + dedupe
      final Map<String, PostEntity> unique = <String, PostEntity>{
        for (final PostEntity p in <PostEntity>[..._posts, ...fetchedPosts])
          p.postID: p
      };
      _posts = unique.values.toList();
      AppLog.info('Total unique posts after merge: ${_posts.length}',
          name: 'FeedProvider._fetchFeed');
    } else if (result is DataFailer) {
      AppLog.error(
        'Feed API failed: ${result.exception?.message ?? 'something_wrong'.tr()}',
        name: 'FeedProvider._fetchFeed',
      );
    } else {
      AppLog.error('Unknown failure in fetching feed',
          name: 'FeedProvider._fetchFeed');
    }
  }

  Future<DataState<bool>> createOffer({
    required BuildContext context,
    required String postId,
    required double offerAmount,
    required String currency,
    required int quantity,
    required String listId,
    required String? size,
    required String? color,
  }) async {
    setIsLoading(true);

    final CreateOfferparams params = CreateOfferparams(
        postId: postId,
        offerAmount: offerAmount,
        currency: currency,
        quantity: quantity,
        listId: listId,
        size: size,
        color: color);
    try {
      final DataState<bool> result = await _createOfferUsecase.call(params);

      if (result is DataSuccess && result.data != null) {
        debugPrint('provider data: ${result.data}');

        final DataState<List<ChatEntity>> chatResult =
            await _getMyChatsUsecase.call(<String>[result.data!]);
        if (chatResult is DataSuccess && chatResult.entity!.isNotEmpty) {
          final ChatProvider chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          chatProvider.setChat(chatResult.entity!.first);
          Navigator.of(context).pushReplacementNamed(
            ChatScreen.routeName,
          );
          return result;
        } else if (chatResult is DataFailer) {
          AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
              name: 'FeedProvider.createOffer - chatResult failed');
        }
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'FeedProvider.createOffer - API failed');
        AppSnackBar.showSnackBar(
            context, result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'FeedProvider.createOffer - catch');
      return DataFailer<bool>(CustomException('$e'));
    } finally {
      setIsLoading(false);
    }
    return DataFailer<bool>(CustomException('something_wrong'.tr()));
  }

  Future<DataState<bool>> updateOffer({
    required BuildContext context,
    required String offerId,
    required String messageID,
    required String chatId,
    String? offerStatus,
    int? quantity,
    int? offerAmount,
    // required int? minoffer,
    String size = '',
    String color = '',
  }) async {
    setIsLoading(true);
    final UpdateOfferParams params = UpdateOfferParams(
      chatID: chatId,
      offerAmount: offerAmount,
      offerStatus: offerStatus,
      quantity: quantity,
      messageId: messageID,
      offerId: offerId,
      size: size,
      color: color,
    );
    try {
      final DataState<bool> result = await _updateOfferUsecase.call(params);
      if (result is DataSuccess && result.data != null) {
        debugPrint('provider data: ${result.data}');
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'FeedProvider.updateOffer - API failed');
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
