import 'package:hive/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../promo/domain/entities/promo_entity.dart';
import '../../../../promo/domain/usecase/get_promo_by_id_usecase.dart';

class LocalPromo {
  static final String boxTitle =
      AppStrings.localPromosBox; // define in constants
  static Box<PromoEntity> get _box => Hive.box<PromoEntity>(boxTitle);

  static Future<Box<PromoEntity>> get openBox async =>
      await Hive.openBox<PromoEntity>(boxTitle);

  Future<Box<PromoEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    return isOpen ? _box : await Hive.openBox<PromoEntity>(boxTitle);
  }

  Future<void> save(PromoEntity value) async {
    await _box.put(value.promoId, value);
  }

  Future<void> saveAll(List<PromoEntity> promos) async {
    final Map<String, PromoEntity> map = <String, PromoEntity>{
      for (PromoEntity promo in promos) promo.promoId: promo,
    };
    await _box.putAll(map);
  }

  Future<void> clear() async => await _box.clear();

  PromoEntity? get(String id) => _box.get(id);

  List<PromoEntity> get all => _box.values.toList();

  DataState<List<PromoEntity>> getByUserId(String? uid) {
    final String userId = uid ?? LocalAuth.uid ?? '';
    if (userId.isEmpty) {
      return DataFailer<List<PromoEntity>>(CustomException('userId is empty'));
    }
    final List<PromoEntity> promos = _box.values.where((PromoEntity promo) {
      return promo.createdBy == userId;
    }).toList();

    return promos.isEmpty
        ? DataFailer<List<PromoEntity>>(CustomException('No promos found'))
        : DataSuccess<List<PromoEntity>>('', promos);
  }

  Future<List<PromoEntity>> getAndUpdateFromServer(String userId) async {
    final GetPromoByIdUsecase usecase = GetPromoByIdUsecase(locator());
    final DataState<List<PromoEntity>> result = await usecase(userId);
    if (result is DataSuccess) {
      await saveAll(result.entity ?? <PromoEntity>[]);
      return result.entity!;
    } else {
      return getByUserId(userId).entity ?? <PromoEntity>[];
    }
  }
}
