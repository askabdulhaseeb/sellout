import '../../../../../core/sources/data_state.dart';
import '../entity/business_entity.dart';

abstract interface class BusinessRepository {
  Future<DataState<BusinessEntity?>> getBusiness(String businessID);
  Future<DataState<List<BusinessEntity>>> getBusinesses();
  Future<DataState<BusinessEntity>> createBusiness(dynamic business);
  Future<DataState<BusinessEntity>> updateBusiness(dynamic business);
  Future<DataState<bool>> deleteBusiness(String businessID);
}
