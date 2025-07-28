import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/service_card/widget/service_card_business_info.dart';
import '../../widgets/service_card/widget/service_card_button.dart';
import '../../widgets/service_card/widget/service_card_detail.dart';
import '../../widgets/service_card/widget/service_card_image_section.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});
  static const String routeName = 'service-detail';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ServiceEntity service = args['service'];
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
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorScheme.of(context).outlineVariant)),
                      child: Column(
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
                                style: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: ColorScheme.of(context)
                                            .outlineVariant),
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
                                style: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: ColorScheme.of(context)
                                            .outlineVariant),
                              )
                            ],
                          ),
                          ServiceCardButton(
                              business: business, service: service),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
