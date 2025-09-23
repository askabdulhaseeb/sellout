import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../business/business_page/views/providers/business_page_provider.dart';
import '../../../../../business/business_page/views/widgets/section_details/empty_lists/business_page_empty_service_widget.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import 'book_quote_screen.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({required this.business, super.key});
  final BusinessEntity business;

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  ServiceEntity? selectedService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusinessPageProvider>(context, listen: false)
          .getServicesByQuery();
    });
  }

  void _openServiceDialog(List<ServiceEntity> services) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'select_service'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ServiceEntity service = services[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CustomNetworkImage(
                              imageURL: service.thumbnailURL,
                              placeholder: service.name,
                            ),
                          ),
                        ),
                        title: Text(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(service.priceStr),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<BookQuoteScreen>(
                              builder: (BuildContext context) =>
                                  BookQuoteScreen(
                                service: service,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'request_quote'),
      ),
      body: Consumer<BusinessPageProvider>(
        builder: (BuildContext context, BusinessPageProvider pagePro, _) {
          final List<ServiceEntity> services = pagePro.services;

          if (pagePro.isLoading) {
            return const Center(child: Loader());
          }
          if (services.isEmpty) {
            return BusinessPageEmptyServiceWidget(business: widget.business);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _openServiceDialog(services),
                  child: Text(selectedService == null
                      ? 'select_service'.tr()
                      : '${'selected_service'.tr()}: ${selectedService!.name}'),
                ),
                if (selectedService != null) ...<Widget>[
                  const SizedBox(height: 20),
                  // Show selected service preview:
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomNetworkImage(
                            imageURL: selectedService!.thumbnailURL,
                            placeholder: selectedService!.name,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${selectedService!.name} • ${selectedService!.priceStr}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
