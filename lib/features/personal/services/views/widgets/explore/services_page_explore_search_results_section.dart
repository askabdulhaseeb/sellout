import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../providers/services_page_provider.dart';
import 'create_quote_dailog.dart';

class ServiceSearchResults extends StatelessWidget {
  const ServiceSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme txt = Theme.of(context).textTheme;
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              'result'.tr(),
              style: txt.titleMedium,
            ),
            SizedBox(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pro.specialOffer.length,
                itemBuilder: (BuildContext context, int index) {
                  final ServiceEntity service = pro.specialOffer[index];
                  return ServiceCard(service: service);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
