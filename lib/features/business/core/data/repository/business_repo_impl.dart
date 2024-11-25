import '../../../../../core/sources/data_state.dart';
import '../../domain/entity/business_entity.dart';
import '../../domain/repository/business_repository.dart';
import '../sources/business_remote_api.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl(this.coreAPI);
  final BusinessCoreAPI coreAPI;

  @override
  Future<DataState<BusinessEntity>> createBusiness(business) {
    // TODO: implement createBusiness
    throw UnimplementedError();
  }

  @override
  Future<DataState<bool>> deleteBusiness(String businessID) {
    // TODO: implement deleteBusiness
    throw UnimplementedError();
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
  Future<DataState<BusinessEntity>> updateBusiness(business) {
    // TODO: implement updateBusiness
    throw UnimplementedError();
  }
}
