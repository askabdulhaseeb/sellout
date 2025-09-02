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
  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'day';
  String _selectedFilter = 'all';

  String? get postId => _postId;
  List<VisitingEntity> get visits => _visits;
  bool get loading => _loading;
  DateTime get selecteddate => _selectedDate;
  String get selectedView => _selectedView;
  String get selectedFilter => _selectedFilter;

  void setPostId(String id) {
    _postId = id;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedView(String view) {
    _selectedView = view;
    notifyListeners();
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
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
