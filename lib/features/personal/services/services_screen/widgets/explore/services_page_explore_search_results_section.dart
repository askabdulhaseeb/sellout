import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import 'services_grid_tile.dart';
import '../../providers/services_page_provider.dart';

class ServiceSearchResults extends StatelessWidget {
  const ServiceSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme txt = Theme.of(context).textTheme;

    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, Widget? child) {
        return Column(
          children: [
            Text(
              'result'.tr(),
              style: txt.titleMedium,
            ),
            SizedBox(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                  childAspectRatio: 0.68,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pro.searchedServices.length,
                itemBuilder: (BuildContext context, int index) {
                  final ServiceEntity service = pro.searchedServices[index];
                  return ServiceGridTile(service: service);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
