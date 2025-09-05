import 'package:flutter/foundation.dart';
import '../../../../../core/sources/api_call.dart';
import '../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';
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

  List<NominationLocationEntity> suggestions = <NominationLocationEntity>[];

  Future<List<NominationLocationEntity>> fetchSuggestions(String query) async {
    if (query.trim().isEmpty) return <NominationLocationEntity>[];

    setLoading(true);

    final DataState<List<NominationLocationEntity>> result =
        await _usecase.call(query);

    if (result is DataSuccess<List<NominationLocationEntity>>) {
      suggestions = result.entity ?? <NominationLocationEntity>[];
    } else {
      suggestions = <NominationLocationEntity>[];
    }

    setLoading(false);
    notifyListeners(); // important to update UI

    return suggestions;
  }
}
