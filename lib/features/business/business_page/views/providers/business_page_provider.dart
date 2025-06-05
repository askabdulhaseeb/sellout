import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
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

  );
  final GetBusinessByIdUsecase _byID;
  final GetServicesListByBusinessIdUsecase _servicesListUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetBookingsListUsecase _getBookingsListUsecase;


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
 }
