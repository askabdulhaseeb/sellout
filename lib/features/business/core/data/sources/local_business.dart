import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../../../../services/get_it.dart';
import '../../domain/entity/business_entity.dart';
import '../../domain/usecase/get_business_by_id_usecase.dart';

class LocalBusiness extends LocalHiveBox<BusinessEntity> {
     @override
  String get boxName => AppStrings.localBusinesssBox;

  Box<BusinessEntity> get _box => box;
  BusinessEntity? business(String id) => _box.get(id);

  DataState<BusinessEntity> dataState(String id) {
    final BusinessEntity? po = business(id);
    if (po == null) {
      return DataFailer<BusinessEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<BusinessEntity>('', po);
    }
  }

  Future<BusinessEntity?> getBusiness(String id) async {
    final BusinessEntity? po = business(id);
    if (po == null) {
      final GetBusinessByIdUsecase getUsercase = GetBusinessByIdUsecase(
        locator(),
      );
      final DataState<BusinessEntity?> result = await getUsercase(id);
      if (result is DataSuccess) {
        return result.entity;
      } else {
        return null;
      }
    } else {
      return po;
    }
  }

  List<BusinessEntity> get all => _box.values.toList();
}
