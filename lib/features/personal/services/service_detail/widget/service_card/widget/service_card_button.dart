import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../visits/view/book_visit/screens/booking_screen.dart';

class ServiceCardButton extends StatelessWidget {
  const ServiceCardButton({
    required this.business,
    required this.service,
    super.key,
  });

  final BusinessEntity? business;
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: <Widget>[
        CustomElevatedButton(
          title: 'book'.tr(),
          bgColor: business?.routine == null
              ? Theme.of(context).disabledColor
              : Theme.of(context).primaryColor,
          isLoading: false,
          onTap: () {
            if (business?.routine != null) {
              AppNavigator.pushNamed(
                BookingScreen.routeName,
                arguments: <String, dynamic>{
                  'service': service,
                  'business': business,
                },
              );
            }
          },
        ),
      ],
    );
  }
}
