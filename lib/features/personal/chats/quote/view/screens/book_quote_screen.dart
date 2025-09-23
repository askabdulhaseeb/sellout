import 'package:flutter/material.dart';

import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../visits/view/book_visit/widgets/booking_calender.dart';
import '../../../../visits/view/book_visit/widgets/booking_profile_image.dart';

class BookQuoteScreen extends StatelessWidget {
  const BookQuoteScreen({required this.service, super.key});
  final ServiceEntity service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'book_quest'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ProductImageWidget(
              image: service.thumbnailURL ?? '',
            ),
            BookingCalendarWidget(
              service: service,
            ),
          ],
        ),
      ),
    );
  }
}
