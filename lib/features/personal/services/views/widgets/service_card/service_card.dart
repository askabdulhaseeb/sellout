import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../providers/services_page_provider.dart';
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
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.entity == null) {
          return const Center(child: Text('No business data available'));
        }
        final BusinessEntity business = snapshot.data!.entity!;
        final TextTheme txt = Theme.of(context).textTheme;
        // final ColorScheme clrsch = Theme.of(context).colorScheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ServiceCardBusinessInfo(
                business: business, txt: txt, service: service),
            ServiceCardImageSection(service: service),
            ServiceCardDetail(service: service),
            ServiceCardButton(business: business, service: service),
          ],
        );
      },
    );
  }
}
