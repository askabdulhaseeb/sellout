import '../../../../../core/sources/data_state.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/data/models/cart/postage_Detail_response_model.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../../domain/repository/postage_repository.dart';
import '../source/remote/postage_remote_source.dart';

class PostageRepositoryImpl implements PostageRepository {
  const PostageRepositoryImpl(this._remoteAPI);
  final PostageRemoteApi _remoteAPI;



  @override
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
      GetPostageDetailParam param) async {
    return await _remoteAPI.getPostageDetails(param);
  }

  @override
  Future<DataState<AddShippingResponseModel>> addShipping(
      SubmitShippingParam param) async {
    return await _remoteAPI.addShipping(param);
  }
}
