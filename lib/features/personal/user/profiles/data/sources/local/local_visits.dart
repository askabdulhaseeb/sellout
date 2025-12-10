import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';

class LocalVisit extends LocalHiveBox<VisitingEntity> {
 @override
  String get boxName => AppStrings.localVisitingsBox;
  static Box<VisitingEntity> get _box =>
      Hive.box<VisitingEntity>(AppStrings.localVisitingsBox);

  static Future<Box<VisitingEntity>> get openBox async =>
      await Hive.openBox<VisitingEntity>(AppStrings.localVisitingsBox);

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
    final List<VisitingEntity> result = _box.values
        .where((VisitingEntity e) => e.visiterID == me)
        .toList();
    return DataSuccess<List<VisitingEntity>>(me, result);
  }

  Future<DataState<List<VisitingEntity>>> visitByPostId(String postID) async {
    if (postID.isEmpty) {
      return DataSuccess<List<VisitingEntity>>(
        '',
        <VisitingEntity>[],
      ); // or your own empty state
    }

    final List<VisitingEntity> result = _box.values
        .where((VisitingEntity e) => e.postID == postID)
        .toList();

    return DataSuccess<List<VisitingEntity>>('', result);
  }

  DataState<List<VisitingEntity>> iMhost() {
    final String me = LocalAuth.uid ?? '';
    if (me.isEmpty) {
      return DataSuccess<List<VisitingEntity>>(me, <VisitingEntity>[]);
    }
    final List<VisitingEntity> result = _box.values
        .where((VisitingEntity e) => e.hostID == me)
        .toList();
    return DataSuccess<List<VisitingEntity>>(me, result);
  }
}
