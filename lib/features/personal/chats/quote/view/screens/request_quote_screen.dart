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
import 'pages/services_step.dart';
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
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
      future: LocalBusiness().getBusiness(widget.businessId),
      builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
        final BusinessEntity? business = snapshot.data;

        return Scaffold(
          appBar: AppBar(title: Text('request_quote'.tr()), centerTitle: true),
          body: Column(
            children: <Widget>[
              StepIndicator(currentStep: _currentStep),
              const Divider(),
              Expanded(
                child: Consumer<QuoteProvider>(
                  builder: (BuildContext context, QuoteProvider pro, _) {
                    if (_currentStep == 0) {
                      return StepServices(businessId: widget.businessId);
                    } else if (_currentStep == 1) {
                      return const StepBooking();
                    } else if (_currentStep == 2) {
                      return const NotesStep();
                    } else if (_currentStep == 3) {
                      return const ReviewStep();
                    } else {
                      return const ReviewStep();
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
                  (ServiceEmployeeEntity s) {
                    final List<String> times = s.bookAt.split(',');
                    return times.length >= s.quantity &&
                        times.every((String t) => t.isNotEmpty);
                  },
                );

                return Row(
                  children: <Widget>[
                    if (_currentStep > 0)
                      Expanded(
                        child: CustomElevatedButton(
                          isLoading: false,
                          onTap: () => setState(() => _currentStep--),
                          title: 'back'.tr(),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),

                    /// Next / Submit button
                    Expanded(
                      child: CustomElevatedButton(
                        isLoading: false,
                        onTap: () {
                          if (_currentStep == 1 && !allHaveTimes) {
                            AppSnackBar.showSnackBar(
                              context,
                              'Please select time for all services',
                              backgroundColor: Colors.red,
                            );
                            return;
                          }

                          if (_currentStep < 3) {
                            setState(() => _currentStep++);
                          } else {
                            Provider.of<QuoteProvider>(context, listen: false)
                                .requestQuote(
                              business?.businessID ?? '',
                              context,
                            );
                          }
                        },
                        title: _currentStep == 3 ? 'submit'.tr() : 'next'.tr(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
