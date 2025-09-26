import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/loader.dart';
import '../../../../../../core/widgets/loaders/loader_container.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../business/business_page/views/widgets/section_details/empty_lists/business_page_empty_service_widget.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../data/models/service_employee_model.dart';
import '../provider/quote_provider.dart';
import '../widgets/service_dropdown.dart';
import 'book_quote_screen.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({required this.businessId, super.key});
  final String businessId;

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
        future: LocalBusiness().getBusiness(widget.businessId),
        builder:
            (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
          final BusinessEntity? business = snapshot.data;
          return PopScope(
            onPopInvokedWithResult: (bool didPop, dynamic result) =>
                Provider.of<QuoteProvider>(context, listen: false)
                    .clearServices(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const AppBarTitle(titleKey: 'request_quote'),
              ),
              bottomNavigationBar: Consumer<QuoteProvider>(
                builder:
                    (BuildContext context, QuoteProvider pro, Widget? child) =>
                        CustomElevatedButton(
                  margin: const EdgeInsets.all(16),
                  onTap: () {
                    pro.requestQuote(business?.businessID ?? '', context);
                  },
                  title: 'request_quote'.tr(),
                  isLoading: pro.isLoading,
                ),
              ),
              body: Consumer<QuoteProvider>(
                builder: (BuildContext context, QuoteProvider pro, _) {
                  final List<ServiceEmployeeModel> services =
                      pro.selectedServices;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ServiceDropdown(
                            businessId: business?.businessID ?? '',
                            onSelected: (ServiceEntity service) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<BookQuoteScreen>(
                                      builder: (BuildContext context) =>
                                          BookQuoteScreen(service: service)));
                            }),
                      ),
                      if (pro.isLoading)
                        const Expanded(child: Center(child: Loader()))
                      else if (services.isEmpty)
                        const Expanded(
                          child: BusinessPageEmptyServiceWidget(),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: services.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ServiceEmployeeModel selected =
                                  services[index];
                              // fetch service info async
                              return RequestQuoteTile(selected: selected);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}

class RequestQuoteTile extends StatelessWidget {
  const RequestQuoteTile({
    required this.selected,
    super.key,
  });

  final ServiceEmployeeModel selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceEntity?>(
      future: LocalService().getService(selected.serviceId),
      builder: (BuildContext context, AsyncSnapshot<ServiceEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderContainer(
            height: 80,
            width: double.infinity,
            borderRadius: 12,
          );
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final ServiceEntity service = snapshot.data!;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorScheme.of(context).outlineVariant,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomNetworkImage(
                    imageURL: service.thumbnailURL,
                    placeholder: service.name,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            service.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'x ${selected.quantity}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.bookAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Provider.of<QuoteProvider>(context, listen: false)
                      .removeService(selected.serviceId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
