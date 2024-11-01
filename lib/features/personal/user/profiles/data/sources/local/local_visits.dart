import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';

class LocalVisit {
  static final String boxTitle = AppStrings.localVisitingsBox;
  static Box<VisitingEntity> get _box => Hive.box<VisitingEntity>(boxTitle);

  static Future<Box<VisitingEntity>> get openBox async =>
      await Hive.openBox<VisitingEntity>(boxTitle);

  Future<Box<VisitingEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<VisitingEntity>(boxTitle);
    }
  }

  Future<void> save(VisitingEntity user) async =>
      await _box.put(user.visitingID, user);
  VisitingEntity? visitingEntity(String value) => _box.get(value);

  DataState<VisitingEntity?> visitingState(String value) {
    final VisitingEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<VisitingEntity?>(value, entity);
    } else {
      return DataFailer<VisitingEntity?>(CustomException('Loading...'));
    }
  }

  DataState<List<VisitingEntity>> iMvisiter() {
    final String me = LocalAuth.uid ?? '';
    if (me.isEmpty) {
      return DataSuccess<List<VisitingEntity>>(me, <VisitingEntity>[]);
    }
    final List<VisitingEntity> result =
        _box.values.where((VisitingEntity e) => e.visiterID == me).toList();
    return DataSuccess<List<VisitingEntity>>(me, result);
  }

  DataState<List<VisitingEntity>> iMhost() {
    final String me = LocalAuth.uid ?? '';
    if (me.isEmpty) {
      return DataSuccess<List<VisitingEntity>>(me, <VisitingEntity>[]);
    }
    final List<VisitingEntity> result =
        _box.values.where((VisitingEntity e) => e.hostID == me).toList();
    return DataSuccess<List<VisitingEntity>>(me, result);
  }
}
