// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../routes/app_linking.dart';
import '../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../business/business_page/domain/usecase/get_my_bookings_usecase.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../domain/usecase/release_payment_usecase.dart';
import '../../../visits/view/book_visit/screens/booking_screen.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../review/views/screens/write_review_screen.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/utils/app_snackbar.dart';
import '../../data/model/hold_service_payment_model.dart';
import '../../domain/params/hold_service_params.dart';
import '../../domain/params/update_appointment_params.dart';
import '../../domain/usecase/hold_service_payment_usecase.dart';
import '../../domain/usecase/update_appointment_usecase.dart';
import '../widgets/appointment_tile_success_payment_bottomsheet.dart';

class AppointmentTileProvider extends ChangeNotifier {
  AppointmentTileProvider(
    this._updateAppointmentUsecase,
    this._holdServicePaymentUsecase,
    this._getBookingUsecase,
    this._releasePaymentUsecase,
  );
  final UpdateAppointmentUsecase _updateAppointmentUsecase;
  final HoldServicePaymentUsecase _holdServicePaymentUsecase;
  final GetMyBookingsListUsecase _getBookingUsecase;
  final ReleasePaymentUsecase _releasePaymentUsecase;

  //
  BusinessEntity? _business;
  BusinessEntity? get business => _business;
  void setbusiness(BusinessEntity? data) {
    _business = data;
  }

  //
  ServiceEntity? _service;
  ServiceEntity? get service => _service;
  void setService(ServiceEntity? data) {
    _service = data;
  }

  //
  UserEntity? _user;
  UserEntity? get user => _user;
  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  //
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> onCancel(BuildContext context, BookingEntity booking) async {
    try {
      setLoading(true);
      final DataState<bool> result = await _updateAppointmentUsecase.call(
        UpdateAppointmentParams(
          bookingID: booking.bookingID,
          newStatus: 'cancel',
          apiKey: 'status',
        ),
      );
      if (result is DataSuccess) {
        setLoading(false);
        return;
      } else {
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'something_wrong',
        );
        setLoading(false);
        return;
      }
    } catch (e) {
      AppSnackBar.showSnackBar(context, e.toString());
      AppLog.error(
        e.toString(),
        name: 'AppointmentTileProvider.onCancel - catch',
        error: e,
      );
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> onBookAgain(BuildContext context, BookingEntity booking) async {
    AppNavigator.pushNamed(
      BookingScreen.routeName,
      arguments: <String, dynamic>{'service': service, 'business': business},
    );
  }

  Future<void> onLeaveReview(
    BuildContext context,
    BookingEntity booking,
  ) async {
    AppNavigator.pushNamed(
      WriteReviewScreen.routeName,
      arguments: <String, dynamic>{'service': service},
    );
  }

  Future<void> onChange(BuildContext context, BookingEntity booking) async {
    Navigator.pushNamed(
      context,
      BookingScreen.routeName,
      arguments: <String, dynamic>{
        'booking': booking,
        'service': service,
        'business': business,
      },
    );
  }

  Future<void> onPayNow(BuildContext context, BookingEntity booking) async {
    final HoldServiceParams holdServiceParams = HoldServiceParams(
      currency: user?.currency ?? '',
      trackId: booking.trackingID ?? '',
    );
    setLoading(true);
    final DataState<HoldServiceResponse> result =
        await _holdServicePaymentUsecase.call(holdServiceParams);

    if (result is DataSuccess<HoldServiceResponse>) {
      final HoldServiceResponse? holdservice = result.entity;
      setLoading(false);
      if (holdservice?.clientSecret != null &&
          holdservice!.clientSecret.isNotEmpty) {
        await showPaymentSheet(context, holdservice);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment could not be initialized')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected response from payment')),
      );
    }
    setLoading(false);
  }

  Future<void> releasePayment(String? transactionId) async {
    setLoading(true);
    debugPrint(transactionId);
    final DataState<bool> result = await _releasePaymentUsecase.call(
      transactionId ?? '',
    );
    setLoading(false);
    if (result is DataSuccess<String>) {
    } else {
      // _errorMessage = result.exception?.message ?? 'realease pay failed';
    }
  }

  Future<void> showPaymentSheet(
    BuildContext context,
    HoldServiceResponse holdserviceresponse,
  ) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: holdserviceresponse.clientSecret,
          // style: ThemeMode.light,
          merchantDisplayName: 'sellout',
          allowsDelayedPaymentMethods: false,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      updateBooking(context, holdserviceresponse.bookingId);
      showSuccessBottomSheet(context);
    } on StripeException catch (e) {
      // Handle Stripe-specific errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment canceled: ${e.error.localizedMessage}'),
        ),
      );
    } catch (e) {
      // Handle general errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }

  Future<void> updateBooking(BuildContext context, String bookingID) async {
    final GetBookingsParams bookingparams = GetBookingsParams(
      bookingID: bookingID,
    );
    setLoading(true);
    await _getBookingUsecase.call(bookingparams);
    setLoading(false);
  }
}
