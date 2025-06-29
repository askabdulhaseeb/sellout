import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../widgets/booking_calender.dart';
import '../widgets/booking_product_detail.dart';
import '../widgets/booking_profile_image.dart';
import '../widgets/book_visit_button.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});
  static String routeName = '/book-viewing';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PostEntity? post = args['post'] as PostEntity?;
    final VisitingEntity? visit = args['visit'] as VisitingEntity?;
    final ServiceEntity? service = args['service'] as ServiceEntity?;
    final BookingEntity? booking = args['booking'] as BookingEntity?;
    final BusinessEntity? business = args['business'] as BusinessEntity?;
    final TextTheme texttheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          booking != null
              ? 'update_booking'.tr()
              : visit != null
                  ? 'update_visit'.tr()
                  : service != null
                      ? 'book_appointment'.tr()
                      : 'book_viewing'.tr(),
          style: texttheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ProductImageWidget(
              image: post?.imageURL ?? service?.thumbnailURL ?? '',
            ),
            BookingCalendarWidget(
              post: post,
              service: service,
              visit: visit,
              business: business,
              booking: booking,
            ),
            if (service != null || booking != null)
              BookViewProductDetail(
                  post: post, service: service, texttheme: texttheme),
            if (visit?.dateTime == null)
              BookVisitButton(post: post, service: service)
          ],
        ),
      ),
    );
  }
}
