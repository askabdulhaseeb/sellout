import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../../../personal/marketplace/domain/params/filter_params.dart';
import '../../../../personal/post/domain/entities/post/post_entity.dart';
import '../../../../personal/review/domain/entities/review_entity.dart';
import '../../../../personal/review/domain/param/get_review_param.dart';
import '../../../../personal/review/domain/usecase/get_reviews_usecase.dart';
import '../../../../personal/services/domain/params/services_by_filters_params.dart';
import '../../../../personal/services/domain/usecase/get_services_by_query_usecase.dart';
import '../../../../personal/user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../../../core/domain/entity/service/service_entity.dart';
import '../../../core/domain/usecase/get_business_by_id_usecase.dart';
import '../../domain/params/get_business_bookings_params.dart';
import '../../domain/usecase/get_bookings_by_service_id_usecase.dart';
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
  final GetServicesByQueryUsecase _servicesListUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetBookingsByServiceIdListUsecase _getBookingsListUsecase;

  BusinessEntity? get business => _business;
  String? get employeeId => _employeeId;
  String? get serviceQuery => _serviceQuery;
  List<PostEntity> get posts => _posts;
  List<ServiceEntity> get services => _services;
  String get serviceLastKey => _serviceLastKey;
  BusinessPageTabType get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  //------------------------------------------------------------------------------------------
  BusinessEntity? _business;
  String? _employeeId;
  String? _serviceQuery;
  final List<PostEntity> _posts = <PostEntity>[];
  final List<ServiceEntity> _services = <ServiceEntity>[];
  String _serviceLastKey = '';
  BusinessPageTabType _selectedTab = BusinessPageTabType.services;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

//---------------------------------------------------------------------------------------------
  set posts(List<PostEntity> value) {
    _posts.clear();
    value.sort((PostEntity a, PostEntity b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    _posts.addAll(value);
    notifyListeners();
  }

  void setServices(List<ServiceEntity> value) {
    value.sort((ServiceEntity a, ServiceEntity b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    _services.addAll(value);
    notifyListeners();
  }

  set business(BusinessEntity? value) {
    _business = value;
    reset();
  }

  set employeeId(String? value) {
    _employeeId = value;
    notifyListeners();
  }

  set serviceQuery(String? value) {
    _serviceQuery = value;
    notifyListeners();
  }

  set serviceLastKey(String value) {
    _serviceLastKey = value;
    notifyListeners();
  }

  set selectedTab(BusinessPageTabType value) {
    _selectedTab = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  reset() {
    _selectedTab = BusinessPageTabType.services;
    _posts.clear();
    _services.clear();
    _serviceLastKey = '';
    _hasMore = true;
    _isLoading = false;
    _isLoadingMore = false;
    _employeeId = business?.employees?.first.uid;
    notifyListeners();
  }

//------------------------------------------------------------------------------------
  ServiceByFiltersParams get servicesParam => ServiceByFiltersParams(
          lastKey: _serviceLastKey,
          query: _serviceQuery ?? '',
          filters: <FilterParam>[
            if (_employeeId != null && _employeeId != '')
              FilterParam(
                  attribute: 'employee_ids',
                  operator: 'inc',
                  value: _employeeId!),
            FilterParam(
                attribute: 'business_id',
                operator: 'eq',
                value: _business?.businessID ?? '')
          ]);
//------------------------------------------------------------------------------------
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

  Future<void> getServicesByQuery({bool reset = false}) async {
    if (reset) {
      _serviceLastKey = '';
      _services.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    if (_serviceLastKey.isEmpty) {
      setLoading(true); // initial load
    } else {
      _isLoadingMore = true; // loading more
      notifyListeners();
    }

    final DataState<List<ServiceEntity>> result =
        await _servicesListUsecase.call(servicesParam);

    if (result is DataSuccess) {
      final List<ServiceEntity> fetched = result.entity ?? <ServiceEntity>[];
      if (reset) {
        _services.clear();
      }
      _services.addAll(fetched);
      _serviceLastKey = result.data ?? '';
      _hasMore = result.data != '';
    } else {
      _hasMore = false;
    }

    _isLoadingMore = false;
    setLoading(false);
    notifyListeners();
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
