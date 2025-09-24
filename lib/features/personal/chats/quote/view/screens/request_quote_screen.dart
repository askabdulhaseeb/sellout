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
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/counter_widget.dart';
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
          if (pagePro.isLoading) return const Center(child: Loader());
          if (services.isEmpty) {
            return BusinessPageEmptyServiceWidget(business: widget.business);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectServiceButton(
                  services: services,
                  selectedService: selectedService,
                  onServiceSelected: (ServiceEntity service) =>
                      setState(() => selectedService = service),
                ),
                if (selectedService != null) ...<Widget>[
                  const SizedBox(height: 20),
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
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class SelectServiceButton extends StatelessWidget {
  const SelectServiceButton({
    required this.services,
    required this.selectedService,
    required this.onServiceSelected,
    super.key,
  });

  final List<ServiceEntity> services;
  final ServiceEntity? selectedService;
  final Function(ServiceEntity) onServiceSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) => ServiceDialog(services: services),
        );
      },
      child: Text(selectedService == null
          ? 'select_service'.tr()
          : '${'selected_service'.tr()}: ${selectedService!.name}'),
    );
  }
}

class ServiceDialog extends StatefulWidget {
  const ServiceDialog({required this.services, super.key});
  final List<ServiceEntity> services;

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  final Map<int, int> quantities = <int, int>{};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                itemCount: widget.services.length,
                itemBuilder: (BuildContext context, int index) {
                  final ServiceEntity service = widget.services[index];
                  quantities.putIfAbsent(index, () => 1);

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
                    title: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            service.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(service.priceStr),
                      ],
                    ),
                    subtitle: PostCounterWidget(
                      initialQuantity: quantities[index]!,
                      maxQuantity: 1000,
                      onChanged: (int value) {
                        setState(() => quantities[index] = value);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<BookQuoteScreen>(
                          builder: (_) => BookQuoteScreen(service: service),
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
  }
}
