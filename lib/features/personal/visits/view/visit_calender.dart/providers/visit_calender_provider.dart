import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../domain/usecase/get_visit_by_post_usecase.dart';

class VisitCalenderProvider extends ChangeNotifier {
  VisitCalenderProvider(this._getVisitByPostUsecase);
  final GetVisitByPostUsecase _getVisitByPostUsecase;

  String? _postId;
  List<VisitingEntity> _visits = <VisitingEntity>[];
  bool _loading = false;

  String? get postId => _postId;
  List<VisitingEntity> get visits => _visits;
  bool get loading => _loading;

  void setPostId(String id) {
    _postId = id;
    notifyListeners();
  }

  Future<void> getPostVisitings() async {
    if (_postId == null || _postId!.isEmpty) return;

    _loading = true;
    notifyListeners();

    final DataState<List<VisitingEntity>> result =
        await _getVisitByPostUsecase.call(_postId!);

    if (result is DataSuccess<List<VisitingEntity>>) {
      _visits = result.entity ?? <VisitingEntity>[];
    } else {
      _visits = <VisitingEntity>[];
      // Optional: Log or handle error
      debugPrint('Error fetching visits: ${result.exception?.message}');
    }

    _loading = false;
    notifyListeners();
  }
}
