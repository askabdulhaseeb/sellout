import '../../../../../core/params/report_params.dart';
import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../entities/post/post_entity.dart';
import '../params/add_to_cart_param.dart';
import '../params/create_offer_params.dart';
import '../params/feed_response_params.dart';
import '../params/get_feed_params.dart';

abstract interface class PostRepository {
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params);
  Future<DataState<PostEntity>> getPost(String id, { required bool silentUpdate});
  Future<DataState<bool>> addToCart(AddToCartParam param);
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> reportPost(ReportParams params);
  Future<DataState<bool>> savePost(String params);
  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param);
}
