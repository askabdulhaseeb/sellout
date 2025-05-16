import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../book_visit/view/screens/view_booking_screen.dart';

class ServiceCardButton extends StatelessWidget {
  const ServiceCardButton({
    required this.business,
    required this.service,
    super.key,
  });

  final BusinessEntity business;
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
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
    );
  }
}
