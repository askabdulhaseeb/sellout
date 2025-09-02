import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../widget/service_detail_cancellation_policy.dart';
import '../widget/service_card/service_card.dart';
import '../widget/review_section/service_detail_review_overview_section.dart';
import '../widget/service_detail_payment_tiles_widget.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});
  static const String routeName = 'service-detail';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ServiceEntity service = args['service'];
    AppLog.info(
      'Opened Service : ${service.serviceID}',
      name: 'ServiceDetailScreen',
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: ColorScheme.of(context).outlineVariant)),
                    child: ServiceCard(service: service)),
                const ServiceDetailCancellationPolicyWidget(),
                const SeviceDetailPaymentTilesWidget(),
                ServiceDetailReviewOverviewSection(service: service)
              ],
            ),
          ),
        ));
  }
}
