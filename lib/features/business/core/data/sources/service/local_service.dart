import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../domain/entity/service/service_entity.dart';
import '../../../domain/usecase/get_service_by_id_usecase.dart';

class LocalService {
  static final String boxTitle = AppStrings.localServicesBox;
  static Box<ServiceEntity> get _box => Hive.box<ServiceEntity>(boxTitle);

  static Future<Box<ServiceEntity>> get openBox async =>
      await Hive.openBox<ServiceEntity>(boxTitle);

  Future<Box<ServiceEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ServiceEntity>(boxTitle);
    }
  }

  Future<void> save(ServiceEntity value) async =>
      await _box.put(value.serviceID, value);

  ServiceEntity? service(String id) => _box.get(id);

  DataState<ServiceEntity> dataState(String id) {
    final ServiceEntity? po = service(id);
    if (po == null) {
      return DataFailer<ServiceEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<ServiceEntity>('', po);
    }
  }

  List<ServiceEntity> byBusinessID(String id) {
    final List<ServiceEntity> list = _box.values
        .where((ServiceEntity element) => element.businessID == id)
        .toList();
    return list;
  }

  Future<ServiceEntity?> getService(String id) async {
    final ServiceEntity? po = service(id);
    if (po == null) {
      final GetServiceByIdUsecase getUsercase =
          GetServiceByIdUsecase(locator());
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

  List<ServiceEntity> get all => _box.values.toList();
}
