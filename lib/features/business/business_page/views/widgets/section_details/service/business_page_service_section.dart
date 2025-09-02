import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../../../../core/domain/entity/business_entity.dart';
import '../../../../../core/domain/entity/service/service_entity.dart';
import '../../../providers/business_page_provider.dart';
import '../../business_page_employee_list_section.dart';
import '../empty_lists/business_page_empty_service_widget.dart';
import '../tile/business_page_service_tile.dart';
import 'business_page_service_filter_section.dart';

class BusinessPageServiceSection extends StatefulWidget {
  const BusinessPageServiceSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  State<BusinessPageServiceSection> createState() =>
      _BusinessPageServiceSectionState();
}

class _BusinessPageServiceSectionState
    extends State<BusinessPageServiceSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusinessPageProvider>(context, listen: false)
          .getServicesByQuery();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BusinessPageServiceFilterSection(business: widget.business),
        BusinessPageEmployeeListSection(business: widget.business),
        Consumer<BusinessPageProvider>(
          builder: (BuildContext context, BusinessPageProvider pagePro, _) {
            final List<ServiceEntity> services = pagePro.services;
            if (pagePro.isLoading) {
              return const Center(child: Loader());
            }
            if (services.isEmpty) {
              return BusinessPageEmptyServiceWidget(business: widget.business);
            }

            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) {
                final ServiceEntity service = services[index];
                return BusinessPageServiceTile(service: service);
              },
            );
          },
        ),
      ],
    );
  }
}
