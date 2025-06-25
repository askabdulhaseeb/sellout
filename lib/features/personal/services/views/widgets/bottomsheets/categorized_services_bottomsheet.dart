import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../providers/services_page_provider.dart';
import '../service_card/service_card.dart';

void showCategorizedServicesSheet(
    BuildContext context, ServiceCategoryType category) {
  final ServicesPageProvider provider =
      Provider.of<ServicesPageProvider>(context, listen: false);

  provider.fetchServicesByCategory(category);

  showBottomSheet(
    clipBehavior: Clip.hardEdge,
    elevation: 100,
    showDragHandle: false,
    enableDrag: false,
    // useSafeArea: true,
    context: context,
    // isDismissible: false,
    // isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Top Bar with Back Button and Title
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.code
                        .tr(), // You can replace this with category.name if preferred
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Content: List of Services
            Flexible(
              child: Consumer<ServicesPageProvider>(
                builder: (_, ServicesPageProvider provider, __) {
                  final List<ServiceEntity> services =
                      provider.categorizedServices;

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (services.isEmpty) {
                    return Center(
                      child: Text('no_services_found'.tr()),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final ServiceEntity service = services[index];
                      return ServiceCard(service: service);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
