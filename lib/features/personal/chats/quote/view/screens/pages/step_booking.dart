import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../data/models/service_employee_model.dart';
import '../../provider/quote_provider.dart';

class StepBooking extends StatelessWidget {
  const StepBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteProvider pro =
        Provider.of<QuoteProvider>(context, listen: false);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'when_would_you_like_appointment'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const AppointmentCard(),
          GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 16),
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: pro.selectedServices.map((ServiceEmployeeModel service) {
              return _ServiceBookigStepCard(
                serviceEmployeeEntity: service,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class _ServiceBookigStepCard extends StatelessWidget {
  const _ServiceBookigStepCard({required this.serviceEmployeeEntity});
  final ServiceEmployeeModel serviceEmployeeEntity;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceEntity?>(
      future: LocalService().getService(serviceEmployeeEntity.serviceId),
      builder: (BuildContext context, AsyncSnapshot<ServiceEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final ServiceEntity? service = snapshot.data;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Service ID / name
              Text(
                'Service: ${service?.name ?? serviceEmployeeEntity.serviceId} (x${serviceEmployeeEntity.quantity})',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              CustomElevatedButton(
                padding: const EdgeInsets.all(4),
                bgColor: Colors.transparent,
                border: Border.all(color: Theme.of(context).primaryColor),
                textStyle: TextTheme.of(context)
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).primaryColor),
                title: 'select_time'.tr(),
                isLoading: false,
                onTap: () {},
              )
            ],
          ),
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteProvider pro =
        Provider.of<QuoteProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorScheme.of(context).outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Toggle: different time per service OR one time for all
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
  }
}

enum AppointmentTimeSelection {
  differentTimePerService('Different time per service'),
  oneTimeForAll('One time for all');

  const AppointmentTimeSelection(this.title);

  final String title;
}
