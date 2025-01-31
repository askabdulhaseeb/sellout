import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loader.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../providers/services_page_provider.dart';

class ServicesPageExploreSpecialOfferSection extends StatelessWidget {
  const ServicesPageExploreSpecialOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
        builder: (BuildContext context, ServicesPageProvider pro, _) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              'special_offers'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            //
            FutureBuilder<List<ServiceEntity>>(
              future: pro.getSpecialOffer(),
              initialData: null,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<ServiceEntity>> snapshot,
              ) {
                final List<ServiceEntity> offers =
                    snapshot.data ?? <ServiceEntity>[];
                return offers.isEmpty &&
                        snapshot.connectionState == ConnectionState.waiting
                    ? const Loader()
                    : offers.isEmpty
                        ? Center(
                            child: const Text('no_special_offers_found').tr(),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: offers.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final ServiceEntity service = offers[index];
                              // return ServiceCard(service: service);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      child: CustomNetworkImage(
                                        size: double.infinity,
                                        imageURL: service.thumbnailURL,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        service.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RatingDisplayWidget(
                                        ratingList: service.listOfReviews,
                                        displayStars: false,
                                      ),
                                      FutureBuilder<BusinessEntity?>(
                                        future: LocalBusiness()
                                            .getBusiness(service.businessID),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<BusinessEntity?>
                                                snapshot) {
                                          final BusinessEntity? business =
                                              snapshot.data;
                                          return business == null
                                              ? const SizedBox()
                                              : Opacity(
                                                  opacity: 0.6,
                                                  child: Text(
                                                    business.location.address,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
              },
            ),
          ],
        ),
      );
    });
  }
}
