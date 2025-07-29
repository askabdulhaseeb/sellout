import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../providers/services_page_provider.dart';
import '../../../../../service_detail/widget/service_card/service_card.dart';

class CategorizedServicesScreen extends StatelessWidget {
  const CategorizedServicesScreen({super.key});
  static const String routeName = '/categorized-services';
  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          titleKey: pro.selectedCategory?.code.tr() ?? 'na'.tr(),
        ),
      ),
      body: Consumer<ServicesPageProvider>(
        builder: (BuildContext context, ServicesPageProvider pro, _) {
          final List<ServiceEntity> services = pro.categorizedServices;
          if (pro.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (services.isEmpty) {
            return Center(
              child: Text(
                'no_results'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (BuildContext context, int index) {
              final ServiceEntity service = services[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceCard(service: service),
              );
            },
          );
        },
      ),
    );
  }
}
