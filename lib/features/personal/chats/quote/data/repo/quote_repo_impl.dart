import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../domain/params/hold_quote_pay_params.dart';
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

  @override
  Future<DataState<bool>> holdQuotePayment(HoldQuotePayParams params) async {
    try {
      final DataState<String> result =
          await remoteDataSource.holdQuotePayment(params);
      if (result is! DataSuccess<String>) {
        return DataFailer<bool>(result.exception!);
      }
      final Map<String, dynamic> map = json.decode(result.data ?? '{}');
      final String clientSecret = map['clientSecret'] ?? '';
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'com.sellout.sellout',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      final PaymentIntent intent =
          await Stripe.instance.retrievePaymentIntent(clientSecret);
      if (intent.status == PaymentIntentsStatus.Succeeded) {
        return DataSuccess<bool>('', true);
      } else {
        return DataFailer<bool>(
            CustomException('Payment not completed: ${intent.status.name}'));
      }
    } on StripeException catch (e, st) {
      AppLog.error('Stripe payment error',
          name: 'holdQuotePayment', error: e, stackTrace: st);
      return DataFailer<bool>(
          CustomException(e.error.message ?? 'Payment failed'));
    } catch (e, st) {
      AppLog.error('Payment failed',
          name: 'holdQuotePayment', error: e, stackTrace: st);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<String>> releaseQuotePayment(String transactionId) async {
    return remoteDataSource.releaseQuotePayment(transactionId);
  }
}
