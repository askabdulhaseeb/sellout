import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../../../personal/chats/chat/views/providers/chat_provider.dart';
import '../../../../personal/chats/chat/views/screens/chat_screen.dart';
import '../../../../personal/chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../personal/chats/chat_dashboard/domain/params/create_private_chat_params.dart';
import '../../../../personal/chats/chat_dashboard/domain/usecase/create_private_chat_usecase.dart';
import '../../../../personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../../personal/post/domain/entities/post_entity.dart';
import '../../../../personal/review/domain/entities/review_entity.dart';
import '../../../../personal/review/domain/param/get_review_param.dart';
import '../../../../personal/review/domain/usecase/get_reviews_usecase.dart';
import '../../../../personal/user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../../../core/domain/usecase/get_business_by_id_usecase.dart';
import '../../domain/entities/services_list_responce_entity.dart';
import '../../domain/params/get_business_bookings_params.dart';
import '../../domain/params/get_business_serives_param.dart';
import '../../domain/usecase/get_business_bookings_list_usecase.dart';
import '../../domain/usecase/get_services_list_by_business_id_usecase.dart';
import '../enum/business_page_tab_type.dart';

class BusinessPageProvider extends ChangeNotifier {
  BusinessPageProvider(
    this._byID,
    this._servicesListUsecase,
    this._getReviewsUsecase,
    this._getPostByIdUsecase,
    this._getBookingsListUsecase,
    this._createPrivateChatUsecase,
    this._getMyChatsUsecase,
  );
  final GetBusinessByIdUsecase _byID;
  final GetServicesListByBusinessIdUsecase _servicesListUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetBookingsListUsecase _getBookingsListUsecase;
  final CreatePrivateChatUsecase _createPrivateChatUsecase;
  final GetMyChatsUsecase _getMyChatsUsecase;

  BusinessEntity? _business;
  BusinessEntity? get business => _business;

  GetBusinessSerivesParam? _servicesListParam;
  GetBusinessSerivesParam? get servicesListParam => _servicesListParam;

  final List<PostEntity> _posts = <PostEntity>[];
  List<PostEntity> get posts => _posts;

  set posts(List<PostEntity> value) {
    _posts.clear();
    value.sort((PostEntity a, PostEntity b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    _posts.addAll(value);
    notifyListeners();
  }

  set servicesListParam(GetBusinessSerivesParam? value) {
    _servicesListParam = value;
    notifyListeners();
  }

  set business(BusinessEntity? value) {
    _business = value;
    reset();
  }

  reset() {
    _selectedTab = BusinessPageTabType.services;
    _servicesListParam = null;
    _posts.clear();
    notifyListeners();
  }

  BusinessPageTabType _selectedTab = BusinessPageTabType.services;
  BusinessPageTabType get selectedTab => _selectedTab;
  set selectedTab(BusinessPageTabType value) {
    _selectedTab = value;
    notifyListeners();
  }

  Future<List<ReviewEntity>> getReviews(String? id) async {
    final DataState<List<ReviewEntity>> reviews =
        await _getReviewsUsecase(GetReviewParam(
      id: id ?? _business?.businessID ?? '',
      type: ReviewApiQueryOptionType.businessID,
    ));
    return reviews.entity ?? <ReviewEntity>[];
  }

  Future<BusinessEntity?> getBusinessByID(String businessID) async {
    if (businessID.isEmpty) return null;
    if (businessID == _business?.businessID) return business;
    // Locad business from remote storage
    final DataState<BusinessEntity?> result = await _byID(businessID);
    if (result.entity == null) {
      return null;
    }
    business = result.entity;
    return business;
  }

  Future<DataState<ServicesListResponceEntity>> getServicesListByBusinessID(
      String businessID) async {
    if (businessID.isEmpty) {
      return DataFailer<ServicesListResponceEntity>(
          CustomException('Business ID is empty'));
    }
    final DataState<ServicesListResponceEntity> result =
        await _servicesListUsecase(
      _servicesListParam ?? GetBusinessSerivesParam(businessID: businessID),
    );
    if (result is DataSuccess) {
      _servicesListParam = GetBusinessSerivesParam(
        businessID: businessID,
        nextKey: result.entity?.nextKey,
        sort: _servicesListParam?.sort ?? 'lowToHigh',
      );
      return result;
    } else {
      return DataFailer<ServicesListResponceEntity>(
          CustomException('Failed to get services list'));
    }
  }

  Future<DataState<List<PostEntity>>> getPostByID(String id) async {
    try {
      if (_posts.isNotEmpty && id == _business?.businessID) {
        AppLog.info(
          'Post length: Lenght: ${_posts.length}',
          name: 'BusinessPageProvider.getPostByID - if',
        );
        return DataSuccess<List<PostEntity>>('', _posts);
      }
      final DataState<List<PostEntity>> result = await _getPostByIdUsecase(
        _business?.businessID ?? '',
      );
      debugPrint('BusinessPageProvider.getPostByID - id: $id');
      if (result is DataSuccess) {
        posts = result.entity ?? <PostEntity>[];
        return DataSuccess<List<PostEntity>>(result.data ?? '', _posts);
      } else {
        AppLog.error(
          'Failed to get post list',
          name: 'BusinessPageProvider.getPostByID - else',
          error: 'Failed to get post list',
        );
        return DataFailer<List<PostEntity>>(
            CustomException('Failed to get post list'));
      }
    } catch (e) {
      AppLog.error(
        'Failed to get post list',
        name: 'BusinessPageProvider.getPostByID - catch',
        error: e.toString(),
      );
      return DataFailer<List<PostEntity>>(
          CustomException('Failed to get post list'));
    }
  }

  Future<DataState<List<BookingEntity>>> getBookings(String businessID) async {
    final DataState<List<BookingEntity>> result = await _getBookingsListUsecase(
      GetBookingsParams(businessID: businessID),
    );
    return result;
  }

  Future<DataState<ChatEntity>> createPrivateChat(context) async {
    try {
      AppLog.info('Creating private chat with ${business?.businessID ?? ''}',
          name: 'BusinessPageProvider.createPrivateChat');
      CreatePrivateChatParams params = CreatePrivateChatParams(
          recieverId: <String>[LocalAuth.uid ?? ''],
          type: 'private',
          businessID: business?.businessID ?? '');
      final DataState<ChatEntity> result =
          await _createPrivateChatUsecase.call(params);
      if (result is DataSuccess) {
        final String chatId = result.entity?.chatId ?? '';
        DataState<List<ChatEntity>> chatresult =
            await _getMyChatsUsecase.call(<String>[chatId]);
        if (chatresult is DataSuccess &&
            (chatresult.data?.isNotEmpty ?? false)) {
          final ChatProvider chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          chatProvider.chat = chatresult.entity!.first;
          Navigator.of(context).pushReplacementNamed(
            ChatScreen.routeName,
            arguments: chatId,
          );
        }
      } else {
        AppLog.error(
          'Failed to create private chat',
          name: 'BusinessPageProvider.createPrivateChat',
          error: result.exception,
        );
      }
      return result;
    } catch (e) {
      AppLog.error(
        'Exception occurred while creating private chat',
        name: 'BusinessPageProvider.createPrivateChat',
        error: CustomException(e.toString()),
      );
      return DataFailer<ChatEntity>(CustomException(e.toString()));
    }
  }
}
