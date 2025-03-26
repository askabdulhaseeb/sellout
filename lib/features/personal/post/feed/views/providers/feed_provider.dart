import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../chats/chat/views/screens/chat_screen.dart';
import '../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/update_offer_params.dart';
import '../../../domain/usecase/create_offer_usecase.dart';
import '../../../domain/usecase/get_feed_usecase.dart';
import '../../../domain/usecase/update_offer_status_usecase.dart';
import '../../../domain/usecase/update_offer_usecase.dart';

class FeedProvider extends ChangeNotifier {
  FeedProvider(
      this._getFeedUsecase,
      this._createOfferUsecase,
      this._getMyChatsUsecase,
      this._updateOfferUsecase,
      this._updateOfferStatusUsecase);
  final GetFeedUsecase _getFeedUsecase;
  final CreateOfferUsecase _createOfferUsecase;
  final UpdateOfferUsecase _updateOfferUsecase;
  final UpdateOfferStatusUsecase _updateOfferStatusUsecase;

  final GetMyChatsUsecase _getMyChatsUsecase;
  final List<PostEntity> _posts = <PostEntity>[];
  bool _isLoading = false;
  List<PostEntity> get feed => _posts;
  String _offerAmount = '';
  String get offerAmount => _offerAmount;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateOfferAmount(String amount) {
    _offerAmount = amount;
    notifyListeners();
  }

  void clearOfferAmount() {
    _offerAmount = '';
    notifyListeners();
  }

  Future<DataState<List<PostEntity>>> getFeed() async {
    final DataState<List<PostEntity>> result = await _getFeedUsecase(null);
    _posts.addAll(result.entity ?? <PostEntity>[]);
    notifyListeners();
    return result;
  }

  Future<DataState<bool>> createOffer({
    required BuildContext context,
    required String postId,
    required double offerAmount,
    required String currency,
    required int quantity,
    required String listId,
    String? size,
    String? color,
  }) async {
    setIsLoading(true);

    final CreateOfferparams params = CreateOfferparams(
        postId: postId,
        offerAmount: offerAmount,
        currency: currency,
        quantity: quantity,
        listId: listId,
        size: size ?? '',
        color: color ?? '');
    try {
      final DataState<bool> result = await _createOfferUsecase.call(params);

      if (result is DataSuccess && result.data != null) {
        debugPrint('provider data: ${result.data}');

        final DataState<List<ChatEntity>> chatResult =
            await _getMyChatsUsecase.call(<String>[result.data!]);

        if (chatResult is DataSuccess && chatResult.entity!.isNotEmpty) {
          final ChatProvider chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          chatProvider.chat = chatResult.entity!.first;

          Navigator.of(context).pushReplacementNamed(
            ChatScreen.routeName,
            arguments: result.data,
          );
          return result;
        } else if (chatResult is DataFailer) {
          AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
              name: 'FeedProvider.createOffer - chatResult failed');
        }
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'FeedProvider.createOffer - API failed');
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
    required String businessId,
    required BuildContext context,
    required String offerStatus,
    required String offerId,
    required String messageID,
    required int? quantity,
    required int? offerAmount,
    required int? minoffer,
    required String chatId,
  }) async {
    setIsLoading(true);
    final UpdateOfferParams params = UpdateOfferParams(
        chatID: chatId,
        minOffer: minoffer,
        offerAmount: offerAmount,
        quantity: quantity,
        businessId: businessId,
        offerStatus: offerStatus,
        messageId: messageID,
        offerId: offerId);
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

    return DataFailer(CustomException('something_wrong'.tr()));
  }

  Future<DataState<bool>> updateOfferStatus({
    required BuildContext context,
    required String offerStatus,
    required String offerId,
    required String chatId,
  }) async {
    setIsLoading(true);
    final UpdateOfferParams params = UpdateOfferParams(
        chatID: chatId,
        minOffer: 0,
        offerAmount: 0,
        quantity: 0,
        businessId: '',
        offerStatus: offerStatus,
        messageId: '',
        offerId: offerId);
    try {
      final DataState<bool> result =
          await _updateOfferStatusUsecase.call(params);
      if (result is DataSuccess && result.data != null) {
        debugPrint('provider data: ${result.data}');
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'FeedProvider.updateOfferStatus - Else');
      }
    } catch (e) {
      AppLog.error(e.toString(),
          name: 'FeedProvider.updateOfferStatus - catch');
      return DataFailer<bool>(CustomException('$e'));
    } finally {
      setIsLoading(false);
    }

    return DataFailer(CustomException('something_wrong'.tr()));
  }
}
