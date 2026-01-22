import '../../../../../core/sources/api_call.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../../data/models/postage_detail_repsonse_model.dart';
import '../entities/service_point_entity.dart';
import '../params/add_label_params.dart';
import '../params/add_order_label_params.dart';
import '../params/get_order_postage_detail_params.dart';
import '../params/get_service_points_param.dart';

abstract interface class PostageRepository {
  Future<DataState<PostageDetailResponseModel>> getPostageDetails(
    GetPostageDetailParam param,
  );
  Future<DataState<AddShippingResponseModel>> addShipping(
    SubmitShippingParam param,
  );
  Future<DataState<PostageDetailResponseModel>> getOrderPostageDetail(
    GetOrderPostageDetailParam param,
  );
  Future<DataState<bool>> buyLabel(BuyLabelParams param);
  Future<DataState<bool>> addOrderShipping(AddOrderShippingParams param);
  Future<DataState<ServicePointsResponseEntity>> getServicePoints(
    GetServicePointsParam param,
  );
}
