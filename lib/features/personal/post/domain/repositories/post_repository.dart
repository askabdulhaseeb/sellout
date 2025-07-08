import '../../../../../core/params/report_params.dart';
import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../entities/post_entity.dart';
import '../params/add_to_cart_param.dart';
import '../params/create_offer_params.dart';
import '../params/feed_response_params.dart';
import '../params/get_feed_params.dart';
import '../params/offer_payment_params.dart';
import '../params/update_offer_params.dart';

abstract interface class PostRepository {
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params);
  Future<DataState<PostEntity>> getPost(String id, {bool silentUpdate = true});
  Future<DataState<bool>> addToCart(AddToCartParam param);
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);
  Future<DataState<bool>> reportPost(ReportParams params);
  Future<DataState<bool>> savePost(String params);
  Future<DataState<String>> offerPayment(OfferPaymentParams param);
  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param);
}
