import '../../../../../core/sources/data_state.dart';
import '../../domain/entity/business_entity.dart';
import '../../domain/entity/service/service_entity.dart';
import '../../domain/repository/business_repository.dart';
import '../sources/business_remote_api.dart';
import '../sources/service/service_remote_api.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl(this.coreAPI, this.serviceRemoteApi);
  final BusinessCoreAPI coreAPI;
  final ServiceRemoteApi serviceRemoteApi;

  @override
  Future<DataState<BusinessEntity>> createBusiness(dynamic business) async {
    return DataFailer<BusinessEntity>(
      CustomException('createBusiness is not yet implemented'),
    );
  }

  @override
  Future<DataState<bool>> deleteBusiness(String businessID) async {
    return DataFailer<bool>(
      CustomException('deleteBusiness is not yet implemented'),
    );
  }

  @override
  Future<DataState<BusinessEntity?>> getBusiness(String businessID) async {
    return await coreAPI.getBusiness(businessID);
  }

  @override
  Future<DataState<List<BusinessEntity>>> getBusinesses() async {
    return await coreAPI.getBusinesses();
  }

  @override
  Future<DataState<BusinessEntity>> updateBusiness(dynamic business) async {
    return DataFailer<BusinessEntity>(
      CustomException('updateBusiness is not yet implemented'),
    );
  }

  @override
  Future<DataState<ServiceEntity?>> getService(String serviceID) async {
    return await serviceRemoteApi.getService(serviceID);
  }
}
