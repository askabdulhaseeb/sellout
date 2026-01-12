import '../../../../../core/sources/data_state.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../../domain/params/add_label_params.dart';
import '../../domain/params/add_order_label_params.dart';
import '../../domain/params/get_order_postage_detail_params.dart';
import '../../domain/repository/postage_repository.dart';
import '../models/postage_detail_repsonse_model.dart';
import '../source/remote/postage_remote_source.dart';

class PostageRepositoryImpl implements PostageRepository {
  const PostageRepositoryImpl(this._remoteAPI);
  final PostageRemoteApi _remoteAPI;

  @override
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
    GetPostageDetailParam param,
  ) async {
    return await _remoteAPI.getPostageDetails(param);
  }

  @override
  Future<DataState<AddShippingResponseModel>> addShipping(
    SubmitShippingParam param,
  ) async {
    return await _remoteAPI.addShipping(param);
  }

  @override
  Future<DataState<PostageDetailResponseModel>> getOrderPostageDetail(
    GetOrderPostageDetailParam param,
  ) async {
    return await _remoteAPI.getOrderPostageDetail(param);
  }

  @override
  Future<DataState<bool>> buyLabel(BuyLabelParams param) async {
    return await _remoteAPI.buylabel(param);
  }

  @override
  Future<DataState<bool>> addOrderShipping(AddOrderShippingParams param) async {
    return await _remoteAPI.addOrderShipping(param);
  }
}
