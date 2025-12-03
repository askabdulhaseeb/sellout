import 'package:flutter/foundation.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecase/location_name_usecase.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider(this._usecase);

  final NominationLocationUsecase _usecase;

  bool _isLoading = false; // initialize
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<LocationEntity> suggestions = <LocationEntity>[];

  Future<List<LocationEntity>> fetchSuggestions(String query) async {
    if (query.trim().isEmpty) return <LocationEntity>[];
    setLoading(true);
    final DataState<List<LocationEntity>> result =
        await _usecase.call(query);

    if (result is DataSuccess<List<LocationEntity>>) {
      suggestions = result.entity ?? <LocationEntity>[];
    } else {
      suggestions = <LocationEntity>[];
    }

    setLoading(false);
    notifyListeners(); // important to update UI

    return suggestions;
  }
}
