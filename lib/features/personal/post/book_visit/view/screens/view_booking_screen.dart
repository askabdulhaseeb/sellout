import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../domain/entities/post_entity.dart';
import '../provider/view_booking_provider.dart';
import '../widgets/booking_calender.dart';
import '../widgets/booking_product_detail.dart';
import '../widgets/booking_profile.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});
  static String routeName = '/book-viewing';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PostEntity post = args['post'] ?? '';
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
            BookingCalendarWidget(availabilities: post.availability),
            const SizedBox(),
            BookViewProductDetail(post: post, texttheme: texttheme),
            const SizedBox(),
            Consumer<BookingProvider>(builder: (BuildContext context,
                BookingProvider provider, Widget? child) {
              return CustomElevatedButton(
                  bgColor: provider.selectedTime != null
                      ? AppTheme.primaryColor
                      : AppTheme.darkScaffldColor.withAlpha(100),
                  title: 'book'.tr(),
                  isLoading: false,
                  onTap: () {
                    provider.setpostId(post.postID);
                    provider.setbusinessId(post.businessID ?? 'null');
                    provider.bookVisit(context);
                  });
            })
          ],
        ),
      ),
    );
  }
}
