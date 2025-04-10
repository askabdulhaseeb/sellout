import '../../../../../core/sources/data_state.dart';
import '../../domain/params/add_service_param.dart';
import '../../domain/repositories/add_service_repository.dart';
import '../sources/add_service_remote_api.dart';

class AddServiceRepositoryImpl implements AddServiceRepository {
  const AddServiceRepositoryImpl(this.remoteApi);
  final AddServiceRemoteApi remoteApi;

  @override
  Future<DataState<bool>> addService(AddServiceParam params) async =>
      await remoteApi.addService(params);
       @override
  Future<DataState<bool>> updateService(AddServiceParam params) async =>
      await remoteApi.updateService(params);
}

