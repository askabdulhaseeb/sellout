import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../services_screen/providers/services_page_provider.dart';
import 'widget/service_card_business_info.dart';
import 'widget/service_card_button.dart';
import 'widget/service_card_detail.dart';
import 'widget/service_card_image_section.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({required this.service, super.key});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);

    return FutureBuilder<DataState<BusinessEntity?>>(
      future: pro.getbusinessbyid(service.businessID),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<BusinessEntity?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final BusinessEntity? business = snapshot.data!.entity;
        final TextTheme txt = Theme.of(context).textTheme;
        // final ColorScheme clrsch = Theme.of(context).colorScheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ServiceCardBusinessInfo(
                business: business, txt: txt, service: service),
            ServiceCardImageSection(service: service),
            ServiceCardDetail(service: service),
            Divider(
              color: ColorScheme.of(context).outlineVariant,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${'includes'.tr()}:'),
                Text(
                  service.included ?? '',
                  style: TextTheme.of(context).bodySmall?.copyWith(
                      color: ColorScheme.of(context)
                          .onSurface
                          .withValues(alpha: 0.5)),
                )
              ],
            ),
            Divider(
              color: ColorScheme.of(context).outlineVariant,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${'does_not_includes'.tr()}:'),
                Text(
                  service.excluded,
                  style: TextTheme.of(context).bodySmall?.copyWith(
                      color: ColorScheme.of(context)
                          .onSurface
                          .withValues(alpha: 0.5)),
                )
              ],
            ),
            ServiceCardButton(business: business, service: service),
          ],
        );
      },
    );
  }
}
