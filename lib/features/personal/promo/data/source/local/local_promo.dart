import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/promo_entity.dart';

class LocalPromo {
  static final String boxTitle = AppStrings.localPromosBox; // add this in your AppStrings
  static Box<PromoEntity> get _box => Hive.box<PromoEntity>(boxTitle);
  static Future<Box<PromoEntity>> get openBox async =>
      await Hive.openBox<PromoEntity>(boxTitle);
  Future<Box<PromoEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<PromoEntity>(boxTitle);
    }
  }
  Future<void> save(PromoEntity value) async =>
      await _box.put(value.promoId, value);

  Future<void> clear() async => await _box.clear();
Future<void> saveAll(List<PromoEntity> promos) async {
  for (final promo in promos) {
    await _box.put(promo.promoId, promo);
  }
}

  PromoEntity? promo(String id) => _box.get(id);

  DataState<PromoEntity> dataState(String id) {
    final PromoEntity? pro = promo(id);
    if (pro == null) {
      return DataFailer<PromoEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<PromoEntity>('', pro);
    }
  }

  List<PromoEntity> get all => _box.values.toList();

  DataState<List<PromoEntity>> promosByCreator(String? value) {
    final String id = value ?? '';
    if (id.isEmpty) {
      return DataFailer<List<PromoEntity>>(CustomException('userId is empty'));
    }
    final List<PromoEntity> promos = _box.values.where((PromoEntity promo) {
      return promo.createdBy == id;
    }).toList();
    if (promos.isEmpty) {
      return DataFailer<List<PromoEntity>>(CustomException('No promo found'));
    } else {
      return DataSuccess<List<PromoEntity>>('', promos);
    }
  }
}
