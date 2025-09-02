import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/models/visit/visiting_model.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';
import '../local/local_visits.dart';

abstract interface class MyVisitingRemote {
  Future<DataState<List<VisitingEntity>>> iMvisiter();
  Future<DataState<List<VisitingEntity>>> postViist();
  Future<DataState<List<VisitingEntity>>> iMhost();
}

class MyVisitingRemoteImpl implements MyVisitingRemote {
  final String me = LocalAuth.uid ?? '';
  @override
  Future<DataState<List<VisitingEntity>>> iMvisiter() async {
    final String endpoint = '/visit/query?visiter_id=$me';
    final DataState<bool> restul = await ApiCall<bool>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
    );
    return await _result(restul);
  }

  @override
  Future<DataState<List<VisitingEntity>>> postViist() async {
    final String endpoint = '/visit/query?visiter_id=$me';
    final DataState<bool> restul = await ApiCall<bool>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
    );
    return await _result(restul);
  }

  @override
  Future<DataState<List<VisitingEntity>>> iMhost() async {
    final String endpoint = '/visit/query?post_id=$me';
    final DataState<bool> restul = await ApiCall<bool>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
    );
    return await _result(restul);
  }

  Future<DataState<List<VisitingEntity>>> _result(
      DataState<bool> restul) async {
    if (restul is DataSuccess<bool>) {
      final String raw = restul.data ?? '';
      final dynamic useable = json.decode(raw);
      final List<dynamic> rawList = useable['items'];

      final List<VisitingEntity> list = <VisitingEntity>[];
      for (dynamic item in rawList) {
        final VisitingEntity visiting = VisitingModel.fromJson(item);
        await LocalVisit().save(visiting);
        list.add(visiting);
      }
      return DataSuccess<List<VisitingEntity>>('Success', list);
    } else {
      return DataFailer<List<VisitingEntity>>(CustomException('Failed'));
    }
  }
}
