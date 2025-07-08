import '../../../../../core/params/report_params.dart';
import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/params/add_to_cart_param.dart';
import '../../domain/params/create_offer_params.dart';
import '../../domain/params/feed_response_params.dart';
import '../../domain/params/get_feed_params.dart';
import '../../domain/params/offer_payment_params.dart';
import '../../domain/params/update_offer_params.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/remote/post_remote_api.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.remoteApi);
  final PostRemoteApi remoteApi;

  @override
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params) async {
    return await remoteApi.getFeed(params);
  }

  @override
  Future<DataState<PostEntity>> getPost(
    String id, {
    bool silentUpdate = false,
  }) async {
    return await remoteApi.getPost(id);
  }

  @override
  Future<DataState<bool>> addToCart(AddToCartParam param) async {
    return await remoteApi.addToCart(param);
  }

  @override
  Future<DataState<bool>> createOffer(CreateOfferparams param) async {
    return await remoteApi.createOffer(param);
  }

  @override
  Future<DataState<bool>> updateOffer(UpdateOfferParams param) async {
    return await remoteApi.updateOffer(param);
  }

  @override
  Future<DataState<String>> offerPayment(OfferPaymentParams param) async {
    return await remoteApi.offerPayment(param);
  }

  @override
  Future<DataState<bool>> reportPost(ReportParams params) async {
    return await remoteApi.reportPost(params);
  }

  @override
  Future<DataState<bool>> savePost(String params) async {
    return await remoteApi.savePost(params);
  }

  // @override
  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param) async {
  //   return await remoteApi.updateOfferStatus(param);
  // }
}
