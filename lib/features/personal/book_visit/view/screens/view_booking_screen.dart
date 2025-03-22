import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../widgets/booking_calender.dart';
import '../widgets/booking_product_detail.dart';
import '../widgets/booking_profile.dart';
import '../widgets/book_visit_button.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});
  static String routeName = '/book-viewing';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PostEntity post = args['post'] ?? '';
    final VisitingEntity? visit = args['visit'] as VisitingEntity?;

    final TextTheme texttheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('book_viewing'.tr(), style: texttheme.titleMedium)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ProductImageWidget(
              post: post.imageURL,
            ),
            BookingCalendarWidget(post: post, visit: visit),
            const SizedBox(),
            BookViewProductDetail(post: post, texttheme: texttheme),
            const SizedBox(),
            if (visit?.dateTime == null)
              BookVisitButton(
                post: post,
              )
          ],
        ),
      ),
    );
  }
}
