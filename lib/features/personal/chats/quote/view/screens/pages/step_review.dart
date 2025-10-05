import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../domain/entites/service_employee_entity.dart';
import '../../provider/quote_provider.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import 'step_booking.dart';

class StepReview extends StatelessWidget {
  const StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteProvider pro = Provider.of<QuoteProvider>(context);

    /// ✅ Load all services in parallel
    return FutureBuilder<List<ServiceEntity?>>(
      future: Future.wait(
        pro.selectedServices.map((ServiceEmployeeEntity s) async {
          try {
            return await LocalService().getService(s.serviceId);
          } catch (e) {
            debugPrint('Error loading service ${s.serviceId}: $e');
            return null;
          }
        }),
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<ServiceEntity?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading services: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final List<ServiceEntity?> services =
            snapshot.data ?? <ServiceEntity?>[];

        if (services.isEmpty) {
          return Center(
            child: Text(
              'no_services_found'.tr(),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        /// ✅ Start of review UI
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 🔹 SERVICES SECTION
              _buildCard(
                context,
                title: 'services'.tr(),
                child: Column(
                  children: pro.selectedServices
                      .asMap()
                      .entries
                      .map((MapEntry<int, ServiceEmployeeEntity> entry) {
                    final int i = entry.key;
                    final ServiceEmployeeEntity s = entry.value;
                    final ServiceEntity? service =
                        (i < services.length) ? services[i] : null;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${service?.name ?? s.serviceId} × ${s.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            '£${(s.quantity * (service?.price ?? 120))}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 SCHEDULE SECTION
              _buildCard(
                context,
                title: 'schedule'.tr(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (pro.appointmentTimeType ==
                        AppointmentTimeSelection.differentTimePerService)
                      ...pro.selectedServices
                          .asMap()
                          .entries
                          .map((MapEntry<int, ServiceEmployeeEntity> entry) {
                        final int i = entry.key;
                        final ServiceEmployeeEntity s = entry.value;
                        final ServiceEntity? service =
                            (i < services.length) ? services[i] : null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  service?.name ?? s.serviceId,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              Text(
                                s.bookAt.isNotEmpty ? s.bookAt : 'na'.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pro.globalBookAt != null &&
                                    pro.globalBookAt!.isNotEmpty
                                ? 'Time: ${pro.globalBookAt}'
                                : 'Time: na'.tr(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 NOTE SECTION
              if (pro.note.text.isNotEmpty)
                _buildCard(
                  context,
                  title: 'note'.tr(),
                  child: Text(
                    pro.note.text,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

              const SizedBox(height: 12),

              /// 🔹 TOTAL SECTION
              _buildCard(
                context,
                title: 'total'.tr(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(),
                    Text(
                      '£${pro.selectedServices.fold<num>(0, (num sum, ServiceEmployeeEntity s) {
                        final ServiceEntity? service = services.firstWhere(
                          (ServiceEntity? se) => se?.serviceID == s.serviceId,
                          orElse: () => null,
                        );
                        return sum + (s.quantity * (service?.price ?? 120));
                      })}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Reusable card builder
  Widget _buildCard(BuildContext context,
      {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorScheme.of(context).outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
