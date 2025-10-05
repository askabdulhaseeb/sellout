import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../domain/entites/service_employee_entity.dart';
import '../provider/quote_provider.dart';
import '../widgets/step_indicator.dart';
import 'pages/step_services.dart';
import 'pages/step_booking.dart';
import 'pages/step_note.dart';
import 'pages/step_review.dart';

/// Enum for the quote steps
enum RequestQuoteStep {
  services,
  booking,
  note,
  review,
}

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
              Provider.of<QuoteProvider>(context, listen: false).reset(),
          child: Scaffold(
            appBar:
                AppBar(title: Text('request_quote'.tr()), centerTitle: true),
            body: Column(
              children: <Widget>[
                StepIndicator(currentStep: _currentStep.index),
                const Divider(),
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
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Consumer<QuoteProvider>(
                builder: (BuildContext context, QuoteProvider pro, _) {
                  final bool allHaveTimes = pro.selectedServices.every(
                    (ServiceEmployeeEntity s) => s.bookAt.isNotEmpty,
                  );
                  return Row(
                    children: <Widget>[
                      if (_currentStep != RequestQuoteStep.services)
                        Expanded(
                          child: CustomElevatedButton(
                            bgColor: Colors.transparent,
                            border: Border.all(
                              color: ColorScheme.of(context).outlineVariant,
                            ),
                            textStyle: TextTheme.of(context).bodySmall,
                            isLoading: false,
                            onTap: () {
                              setState(() {
                                _currentStep = RequestQuoteStep
                                    .values[_currentStep.index - 1];
                              });
                            },
                            title: 'back'.tr(),
                          ),
                        ),
                      if (_currentStep != RequestQuoteStep.services)
                        const SizedBox(width: 12),

                      /// Next / Submit button
                      Expanded(
                        child: CustomElevatedButton(
                          isLoading: false,
                          onTap: () {
                            if (_currentStep == RequestQuoteStep.booking &&
                                !allHaveTimes) {
                              AppSnackBar.showSnackBar(
                                context,
                                'Please select time for all services',
                                backgroundColor: Colors.red,
                              );
                              return;
                            }

                            if (_currentStep != RequestQuoteStep.review) {
                              setState(() {
                                _currentStep = RequestQuoteStep
                                    .values[_currentStep.index + 1];
                              });
                            } else {
                              Provider.of<QuoteProvider>(context, listen: false)
                                  .requestQuote(
                                business?.businessID ?? '',
                                context,
                              );
                            }
                          },
                          title: _currentStep == RequestQuoteStep.review
                              ? 'submit_request'.tr()
                              : 'next'.tr(),
                          textStyle: TextTheme.of(context).bodySmall?.copyWith(
                              color: ColorScheme.of(context).onPrimary),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
