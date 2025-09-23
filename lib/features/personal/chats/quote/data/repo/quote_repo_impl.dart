import '../../../../../../core/sources/api_call.dart';
import '../../domain/params/request_quote_service_params.dart';
import '../../domain/params/update_quote_params.dart';
import '../../domain/repo/quote_repo.dart';
import '../source/remote/quote_remote_api.dart';

class QuoteRepoImpl implements QuoteRepo {
  QuoteRepoImpl(this.remoteDataSource);
  final QuoteRemoteDataSource remoteDataSource;

  @override
  Future<DataState<bool>> requestQuote(RequestQuoteParams params) async {
    return await remoteDataSource.requestQuote(params);
  }

  @override
  Future<DataState<bool>> updateQuote(UpdateQuoteParams params) async {
    return await remoteDataSource.updateQuote(params);
  }

  @override
  Future<DataState<bool>> createQuote(bool params) async {
    return await remoteDataSource.createQuote(params);
  }
}
