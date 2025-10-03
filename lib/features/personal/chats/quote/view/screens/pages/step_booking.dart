import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../data/models/service_employee_model.dart';
import '../../../domain/entites/service_employee_entity.dart';
import '../../provider/quote_provider.dart';
import '../book_quote_screen.dart';

class StepBooking extends StatelessWidget {
  const StepBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (BuildContext context, QuoteProvider pro, _) {
        final Map<String, ServiceEmployeeModel> serviceMap =
            <String, ServiceEmployeeModel>{};
        for (final ServiceEmployeeEntity s in pro.selectedServices) {
          if (serviceMap.containsKey(s.serviceId)) {
            serviceMap[s.serviceId]!.quantity += s.quantity;
          } else {
            serviceMap[s.serviceId] = ServiceEmployeeModel(
              bookAt: s.bookAt,
              serviceId: s.serviceId,
              quantity: s.quantity,
            );
          }
        }
        final List<ServiceEmployeeModel> aggregatedServices =
            serviceMap.values.toList();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Title
              Text(
                'when_would_you_like_appointment'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              /// Appointment toggle card
              const AppointmentCard(),
              const SizedBox(height: 16),

              /// Grid of aggregated selected services
              GridView.count(
                padding: const EdgeInsets.symmetric(vertical: 8),
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: aggregatedServices
                    .map(
                      (ServiceEmployeeModel service) => _ServiceBookingStepCard(
                        serviceEmployeeEntity: service,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceBookingStepCard extends StatelessWidget {
  const _ServiceBookingStepCard({required this.serviceEmployeeEntity});
  final ServiceEmployeeModel serviceEmployeeEntity;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceEntity?>(
      future: LocalService().getService(serviceEmployeeEntity.serviceId),
      builder: (BuildContext context, AsyncSnapshot<ServiceEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            decoration: _boxDecoration(context),
            child: const CircularProgressIndicator(),
          );
        }
        final ServiceEntity? service = snapshot.data;
        return Consumer<QuoteProvider>(
          builder: (BuildContext context, QuoteProvider pro, Widget? child) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: _boxDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Service name + qty
                  Text(
                    '${service?.name ?? serviceEmployeeEntity.serviceId} (x${serviceEmployeeEntity.quantity})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  if (serviceEmployeeEntity.bookAt.isNotEmpty)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            serviceEmployeeEntity.bookAt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    )
                  else
                    CustomElevatedButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      bgColor: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      textStyle:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                      title: 'select_time'.tr(),
                      isLoading: false,
                      onTap: () {
                        if (service != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute<BookQuoteScreen>(
                              builder: (BuildContext context) =>
                                  BookQuoteScreen(
                                serviceEmployee: serviceEmployeeEntity,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (BuildContext context, QuoteProvider pro, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomToggleSwitch<AppointmentTimeSelection>(
                labels: const <AppointmentTimeSelection>[
                  AppointmentTimeSelection.differentTimePerService,
                  AppointmentTimeSelection.oneTimeForAll,
                ],
                labelStrs: AppointmentTimeSelection.values
                    .map((AppointmentTimeSelection e) => e.title.tr())
                    .toList(),
                labelText: '',
                onToggle: (AppointmentTimeSelection? val) {
                  if (val != null) pro.setAppointmentTimeType(val);
                },
                initialValue: pro.appointmentTimeType,
              ),
            ],
          ),
        );
      },
    );
  }
}

enum AppointmentTimeSelection {
  differentTimePerService('different_time_per_service'),
  oneTimeForAll('one_time_for_all');

  const AppointmentTimeSelection(this.title);
  final String title;
}
