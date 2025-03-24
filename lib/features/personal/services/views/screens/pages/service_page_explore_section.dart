import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../book_visit/view/screens/view_booking_screen.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/explore/services_page_explore_categories_section.dart';
import '../../widgets/explore/services_page_explore_searching_section.dart';
import '../../widgets/explore/services_page_explore_special_offer_section.dart';

class ServicePageExploreSection extends StatefulWidget {
  const ServicePageExploreSection({super.key});

  @override
  State<ServicePageExploreSection> createState() =>
      _ServicePageExploreSectionState();
}

class _ServicePageExploreSectionState extends State<ServicePageExploreSection> {
  @override
  void initState() {
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);
    pro.getSpecialOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ServicesPageExploreSearchingSection(),
          ServicesPageExploreCategoriesSection(),
          ServicesPageExploreSpecialOfferSection(),
          ServiceSearchResults()
        ],
      ),
    );
  }
}

class ServiceSearchResults extends StatelessWidget {
  const ServiceSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme txt = Theme.of(context).textTheme;
    // ColorScheme clrsch = Theme.of(context).colorScheme;

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
                  return FutureBuilder<DataState<BusinessEntity?>>(
                    future: pro.getbusinessbyid(service.businessID),
                    builder: (BuildContext context,
                        AsyncSnapshot<DataState<BusinessEntity?>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data?.entity == null) {
                        return const Center(
                            child: Text('No business data available'));
                      }
                      final BusinessEntity business = snapshot.data!.entity!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      service.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Row(
                                      children: <Widget>[
                                        Text('5.0',
                                            style: TextStyle(
                                                color: Colors.orange)),
                                        Icon(Icons.star,
                                            color: Colors.orange, size: 16),
                                        Text(' (2,654)',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    Text(
                                      business.displayName ?? '',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomNetworkImage(
                                imageURL: service.thumbnailURL),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(service.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            CupertinoIcons.chat_bubble)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(CupertinoIcons.share)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            CupertinoIcons.archivebox)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('\$${service.price}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 10),
                                    Text(service.time.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  service.description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          CustomElevatedButton(
                            title: 'book'.tr(),
                            isLoading: false,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BookingScreen.routeName,
                                  arguments: <String, ServiceEntity>{
                                    'service': service
                                  });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
