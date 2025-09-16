import '../../../../../core/params/report_params.dart';
import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/post/post_entity.dart';
import '../../domain/params/add_to_cart_param.dart';
import '../../domain/params/create_offer_params.dart';
import '../../domain/params/feed_response_params.dart';
import '../../domain/params/get_feed_params.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/remote/offer_remote_api.dart';
import '../sources/remote/post_remote_api.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.postRemoteApi, this.offerRemoteApi);
  final PostRemoteApi postRemoteApi;
  final OfferRemoteApi offerRemoteApi;

  @override
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params) async {
    return await postRemoteApi.getFeed(params);
  }

  @override
  Future<DataState<PostEntity>> getPost(
    String id, {
    bool silentUpdate = true,
  }) async {
    return await postRemoteApi.getPost(id, silentUpdate: silentUpdate);
  }

  @override
  Future<DataState<bool>> addToCart(AddToCartParam param) async {
    return await postRemoteApi.addToCart(param);
  }

  @override
  Future<DataState<bool>> createOffer(CreateOfferparams param) async {
    return await offerRemoteApi.createOffer(param);
  }

  @override
  Future<DataState<bool>> reportPost(ReportParams params) async {
    return await postRemoteApi.reportPost(params);
  }

  @override
  Future<DataState<bool>> savePost(String params) async {
    return await postRemoteApi.savePost(params);
  }
}
