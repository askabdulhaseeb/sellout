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
        // 🔹 Aggregate services to avoid duplicates
        final Map<String, ServiceEmployeeModel> serviceMap = {};
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

        final bool isGlobal =
            pro.appointmentTimeType == AppointmentTimeSelection.oneTimeForAll;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'when_would_you_like_appointment'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const AppointmentCard(),
              const SizedBox(height: 16),
              if (isGlobal)
                _GlobalAppointmentCard(services: aggregatedServices)
              else
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
                        (ServiceEmployeeModel service) =>
                            _ServiceBookingStepCard(
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

/// 🔹 Single card for "One time for all"
class _GlobalAppointmentCard extends StatelessWidget {
  const _GlobalAppointmentCard({required this.services});
  final List<ServiceEmployeeModel> services;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (BuildContext context, QuoteProvider pro, _) {
        final String displayTime = pro.globalBookAt ?? '';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'all_services'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // 🔹 Show list of services
              ...services.map((ServiceEmployeeModel s) {
                return FutureBuilder<ServiceEntity?>(
                  future: LocalService().getService(s.serviceId),
                  builder: (BuildContext context,
                      AsyncSnapshot<ServiceEntity?> snapshot) {
                    final String name = snapshot.data?.name ?? s.serviceId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '• $name (x${s.quantity})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 16),
              if (displayTime.isNotEmpty)
                Text(
                  'Selected Time: $displayTime',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              const SizedBox(height: 8),

              CustomElevatedButton(
                title: displayTime.isEmpty
                    ? 'select_time'.tr()
                    : 'change_time'.tr(),
                isLoading: false,
                onTap: () async {
                  final String? selectedTime = await Navigator.push(
                    context,
                    MaterialPageRoute<String>(
                      builder: (BuildContext context) => BookQuoteScreen(
                        serviceEmployee: services.first,
                      ),
                    ),
                  );

                  if (selectedTime != null && selectedTime.isNotEmpty) {
                    pro.setGlobalBookAt(selectedTime);
                  }
                },
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
            /// 🔹 Determine which time to show (global or individual)
            final bool useGlobal = pro.appointmentTimeType ==
                AppointmentTimeSelection.oneTimeForAll;
            final String displayTime = useGlobal
                ? (pro.globalBookAt ?? '')
                : serviceEmployeeEntity.bookAt;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: _boxDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// 🔹 Service name + quantity
                  Text(
                    '${service?.name ?? serviceEmployeeEntity.serviceId} (x${serviceEmployeeEntity.quantity})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),

                  /// 🔹 Time display or selection button
                  if (displayTime.isNotEmpty)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            displayTime,
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
                      onTap: () async {
                        if (service == null) return;

                        final String? selectedTime = await Navigator.push(
                          context,
                          MaterialPageRoute<String>(
                            builder: (BuildContext context) => BookQuoteScreen(
                              serviceEmployee: serviceEmployeeEntity,
                            ),
                          ),
                        );

                        /// 🔹 Save selection properly (global or per service)
                        if (selectedTime != null && selectedTime.isNotEmpty) {
                          if (useGlobal) {
                            pro.setGlobalBookAt(selectedTime);
                          } else {
                            pro.setServiceTime(
                                serviceEmployeeEntity.serviceId, selectedTime);
                          }
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

/// 🔹 Appointment mode selection enum
enum AppointmentTimeSelection {
  differentTimePerService('different_time_per_service'),
  oneTimeForAll('one_time_for_all');

  const AppointmentTimeSelection(this.title);
  final String title;
}
