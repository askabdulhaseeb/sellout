import '../../../../../core/sources/api_call.dart';
import '../params/add_service_param.dart';

abstract interface class AddServiceRepository {
  Future<DataState<bool>> addService(AddServiceParam params);
}
