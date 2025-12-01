import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../domain/entity/service/service_entity.dart';
import '../../../domain/usecase/get_service_by_id_usecase.dart';

class LocalService extends LocalHiveBox<ServiceEntity> {
 @override
  String get boxName => AppStrings.localServicesBox;

  ServiceEntity? service(String id) => box.get(id);

  DataState<ServiceEntity> dataState(String id) {
    final ServiceEntity? po = service(id);
    if (po == null) {
      return DataFailer<ServiceEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<ServiceEntity>('', po);
    }
  }

  List<ServiceEntity> byBusinessID(String id) {
    final List<ServiceEntity> list = box.values
        .where((ServiceEntity element) => element.businessID == id)
        .toList();
    return list;
  }

  Future<ServiceEntity?> getService(String id) async {
    final ServiceEntity? po = service(id);
    if (po == null) {
      final GetServiceByIdUsecase getUsercase = GetServiceByIdUsecase(
        locator(),
      );
      final DataState<ServiceEntity?> result = await getUsercase(id);
      if (result is DataSuccess) {
        return result.entity;
      } else {
        return null;
      }
    } else {
      return po;
    }
  }

  List<ServiceEntity> get all => box.values.toList();
}
