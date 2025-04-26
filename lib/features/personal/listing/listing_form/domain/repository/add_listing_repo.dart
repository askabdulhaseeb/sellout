import '../../../../../../core/sources/api_call.dart';
import '../../views/params/add_listing_param.dart';

abstract interface class AddListingRepo {
  Future<DataState<String>> addListing(AddListingParam params);
  Future<DataState<String>> editListing(AddListingParam params);
}
