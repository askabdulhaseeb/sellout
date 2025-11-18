import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../domain/enums/cart_type.dart';
import '../../../providers/cart_provider.dart';

class CartPaymentPage extends StatefulWidget {
  const CartPaymentPage({super.key});

  @override
  State<CartPaymentPage> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends State<CartPaymentPage> {
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => !_isBusy,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Text('processing_payment'.tr()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
    });

    final CartProvider cartPro = context.read<CartProvider>();
    try {
      final DataState<String> billingState = await cartPro.getBillingDetails();
      final String? clientSecret = billingState.entity;

      if (clientSecret == null || clientSecret.isEmpty) {
        _returnToReview(
          message: 'payment_failed'.tr(),
          isError: true,
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: Localizations.localeOf(context).toLanguageTag(),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (!mounted) return;
      Navigator.pop(context);
    } on StripeException catch (e) {
      final String message = e.error.message ?? 'payment_failed'.tr();
      _returnToReview(
        message: '$message. ${'try_again'.tr()}',
        isError: true,
      );
    } catch (e) {
      _returnToReview(
        message: '${'payment_failed'.tr()}. ${'try_again'.tr()}',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _returnToReview({required String message, bool isError = false}) {
    if (!mounted) return;
    AppSnackBar.show(message);
    context.read<CartProvider>().setCartType(CartType.reviewOrder);
  }
}
