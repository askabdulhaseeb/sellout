import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/params/add_to_cart_param.dart';
import '../../domain/params/create_offer_params.dart';
import '../../domain/params/update_offer_params.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/remote/post_remote_api.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.remoteApi);
  final PostRemoteApi remoteApi;

  @override
  Future<DataState<List<PostEntity>>> getFeed() async {
    return await remoteApi.getFeed();
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

  // @override
  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param) async {
  //   return await remoteApi.updateOfferStatus(param);
  // }
}
