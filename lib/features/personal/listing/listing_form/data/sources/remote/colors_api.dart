import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../models/color_option_model.dart';
import '../local/local_colors.dart';

class ColorOptionsApi {
  Future<List<ColorOptionModel>> getColors() async {
    try {
      final DataState<String> response = await ApiCall<String>().call(
        endpoint: '/colour', // Adjust the endpoint as needed
        requestType: ApiRequestType.get,
        isAuth: false,
        isConnectType: false,
      );

      if (response is DataSuccess) {
        final Map<String, dynamic> decoded = json.decode(response.data ?? '{}');
        final List<ColorOptionModel> colors =
            ColorOptionModel.listFromApi(decoded);

        // Save to local
        await LocalColors().saveAll(colors);

        return colors;
      } else if (response is DataFailer) {
        AppLog.error(
          'ColorOptionsApi: API failed -> ${response.exception?.message}',
          name: 'ColorOptionsApi.getColors',
          error: response.exception,
        );

        // Fallback: load local
        return LocalColors()
            .colors
            .map((ColorOptionEntity e) => ColorOptionModel.fromEntity(e))
            .toList();
      } else {
        AppLog.error(
          'ColorOptionsApi: Unknown DataState -> ${response.runtimeType}',
          name: 'ColorOptionsApi.getColors',
        );

        return LocalColors()
            .colors
            .map((ColorOptionEntity e) => ColorOptionModel.fromEntity(e))
            .toList();
      }
    } catch (e) {
      AppLog.error(
        'ColorOptionsApi: Exception -> $e',
        name: 'ColorOptionsApi.getColors',
        error: e,
      );
      // Fallback: load local
      return LocalColors()
          .colors
          .map((ColorOptionEntity e) => ColorOptionModel.fromEntity(e))
          .toList();
    }
  }
}
