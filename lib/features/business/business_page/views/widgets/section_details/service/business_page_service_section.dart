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
  const BusinessPageServiceSection({
    required this.business,
    required this.scrollController,
    super.key,
  });

  final BusinessEntity business;
  final ScrollController scrollController;

  @override
  State<BusinessPageServiceSection> createState() =>
      _BusinessPageServiceSectionState();
}

class _BusinessPageServiceSectionState
    extends State<BusinessPageServiceSection> {
  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusinessPageProvider>(context, listen: false)
          .getServicesByQuery(reset: true);
    });
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    final double maxScroll = widget.scrollController.position.maxScrollExtent;
    final double currentScroll = widget.scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      final BusinessPageProvider provider =
          Provider.of<BusinessPageProvider>(context, listen: false);
      if (!provider.isLoadingMore && provider.hasMore) {
        provider.getServicesByQuery(reset: false);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
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
            if (pagePro.isLoading && services.isEmpty) {
              return const Center(child: Loader());
            }
            if (services.isEmpty) {
              return const BusinessPageEmptyServiceWidget();
            }
            return ListView.builder(
              controller: null,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: services.length + (pagePro.isLoadingMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index < services.length) {
                  return BusinessPageServiceTile(service: services[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Loader()),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
