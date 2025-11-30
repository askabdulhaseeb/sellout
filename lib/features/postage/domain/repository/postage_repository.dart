import '../../../../../core/sources/api_call.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/data/models/cart/postage_Detail_response_model.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../personal/basket/domain/param/submit_shipping_param.dart';

abstract interface class PostageRepository {
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
      GetPostageDetailParam param);
  Future<DataState<AddShippingResponseModel>> addShipping(
      SubmitShippingParam param);
}
