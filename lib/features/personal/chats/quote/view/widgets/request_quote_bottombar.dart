import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../domain/entites/service_employee_entity.dart';
import '../enums/request_quote_steps.dart';
import '../provider/quote_provider.dart';

class RequestQuoteBottomBar extends StatelessWidget {
  const RequestQuoteBottomBar({
    required this.currentStep,
    required this.business,
    required this.onStepChanged,
    super.key,
  });

  final RequestQuoteStep currentStep;
  final BusinessEntity? business;
  final ValueChanged<RequestQuoteStep> onStepChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Consumer<QuoteProvider>(
        builder: (BuildContext context, QuoteProvider pro, _) {
          final bool allHaveTimes = pro.selectedServices.every(
            (ServiceEmployeeEntity s) => s.bookAt.isNotEmpty,
          );

          final bool containServices = pro.selectedServices.isNotEmpty;

          return Row(
            children: <Widget>[
              if (currentStep != RequestQuoteStep.services)
                Expanded(
                  child: CustomElevatedButton(
                    bgColor: Colors.transparent,
                    border: Border.all(
                      color: ColorScheme.of(context).outlineVariant,
                    ),
                    textStyle: TextTheme.of(context).bodyMedium,
                    isLoading: false,
                    onTap: () {
                      onStepChanged(
                        RequestQuoteStep.values[currentStep.index - 1],
                      );
                    },
                    title: 'back'.tr(),
                  ),
                ),
              if (currentStep != RequestQuoteStep.services)
                const SizedBox(width: 12),
              Expanded(
                child: CustomElevatedButton(
                  isLoading: false,
                  onTap: () {
                    // Validate service selection
                    if (currentStep == RequestQuoteStep.services &&
                        !containServices) {
                      AppSnackBar.error(
                        context,
                        'please_select_at_least_one_service'.tr(),
                      );
                      return;
                    }

                    // Validate time selection
                    if (currentStep == RequestQuoteStep.booking &&
                        !allHaveTimes) {
                      AppSnackBar.error(
                        context,
                        'please_select_time_for_all_services'.tr(),
                      );
                      return;
                    }

                    // Move to next or submit
                    if (currentStep != RequestQuoteStep.review) {
                      onStepChanged(
                        RequestQuoteStep.values[currentStep.index + 1],
                      );
                    } else {
                      context.read<QuoteProvider>().requestQuote(
                        business?.businessID ?? '',
                        context,
                      );
                    }
                  },
                  title: currentStep == RequestQuoteStep.review
                      ? 'submit_request'.tr()
                      : 'next'.tr(),
                  textStyle: TextTheme.of(context).bodyMedium?.copyWith(
                    color: ColorScheme.of(context).onPrimary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
