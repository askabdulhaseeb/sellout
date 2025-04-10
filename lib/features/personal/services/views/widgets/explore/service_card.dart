import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/expandable_text_widget.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../book_visit/view/screens/view_booking_screen.dart';
import '../../providers/services_page_provider.dart';

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(business.displayName ?? '',
                              style: txt.titleMedium),
                          const SizedBox(width: 6),
                          RatingDisplayWidget(
                            size: 12,
                            ratingList: service.listOfReviews,
                            displayStars: false,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          business.address?.firstAddress ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextTheme.of(context).bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkImage(imageURL: service.thumbnailURL),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(service.name,
                          style: TextTheme.of(context)
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.chat_bubble,
                            size: 14,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.share,
                            size: 14,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.archivebox,
                            size: 14,
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '\$${service.price}',
                        style: TextTheme.of(context)
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                          text: TextSpan(
                              style: TextTheme.of(context).bodySmall,
                              children: <InlineSpan>[
                            TextSpan(text: '${service.time.toString()} '),
                            TextSpan(
                              text: 'min'.tr(),
                            )
                          ])),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ExpandableText(text: service.description),
                ],
              ),
            ),
            CustomElevatedButton(
              title: 'book'.tr(),
              bgColor: business.routine == null
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).primaryColor,
              isLoading: false,
              onTap: () {
                if (business.routine != null) {
                  Navigator.pushNamed(context, BookingScreen.routeName,
                      arguments: <String, dynamic>{
                        'service': service,
                        'business': business
                      });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
