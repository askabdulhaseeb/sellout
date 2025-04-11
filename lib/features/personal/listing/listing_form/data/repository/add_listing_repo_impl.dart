import '../../../../../../core/sources/data_state.dart';
import '../../domain/repository/add_listing_repo.dart';
import '../../views/params/add_listing_param.dart';
import '../sources/remote/add_listing_remote_api.dart';

class AddListingRepoImpl implements AddListingRepo {
  AddListingRepoImpl(this.remoteApi);
  final AddListingRemoteApi remoteApi;

  @override
  Future<DataState<String>> addListing(AddListingParam params) {
    return remoteApi.addListing(params);
  }
}
