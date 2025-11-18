import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../enums/request_quote_steps.dart';
import '../provider/quote_provider.dart';
import '../widgets/request_quote_bottombar.dart';
import '../widgets/step_indicator.dart';
import 'pages/step_services.dart';
import 'pages/step_booking.dart';
import 'pages/step_note.dart';
import 'pages/step_review.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({required this.businessId, super.key});
  final String businessId;

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  RequestQuoteStep _currentStep = RequestQuoteStep.services;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
      future: LocalBusiness().getBusiness(widget.businessId),
      builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
        final BusinessEntity? business = snapshot.data;
        return PopScope(
          onPopInvokedWithResult: (bool didPop, dynamic result) =>
              context.read<QuoteProvider>().reset(),
          child: Scaffold(
            appBar:
                AppBar(title: Text('request_quote'.tr()), centerTitle: true),
            body: Column(
              children: <Widget>[
                StepIndicator(
                  currentStep: _currentStep,
                  onToggle: (RequestQuoteStep value) {},
                ),
                Expanded(
                  child: Consumer<QuoteProvider>(
                    builder: (BuildContext context, QuoteProvider pro, _) {
                      switch (_currentStep) {
                        case RequestQuoteStep.services:
                          return StepServices(businessId: widget.businessId);
                        case RequestQuoteStep.booking:
                          return const StepBooking();
                        case RequestQuoteStep.note:
                          return const StepNote();
                        case RequestQuoteStep.review:
                          return const StepReview();
                      }
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: RequestQuoteBottomBar(
              currentStep: _currentStep,
              business: business,
              onStepChanged: (RequestQuoteStep step) {
                setState(() => _currentStep = step);
              },
            ),
          ),
        );
      },
    );
  }
}
