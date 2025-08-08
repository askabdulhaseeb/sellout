import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../routes/app_linking.dart';
import '../../../../../../../../../book_visit/view/screens/booking_screen.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import 'widgets/post_make_offer_button.dart';

class PostVehicleButtonTile extends StatelessWidget {
  const PostVehicleButtonTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (post.acceptOffers == false)
          CustomElevatedButton(
            title: 'book_visit'.tr(),
            isLoading: false,
            onTap: () {
              AppNavigator.pushNamed(BookingScreen.routeName,
                  arguments: <String, dynamic>{'post': post});
            },
          ),
        if (post.acceptOffers == true)
          Column(
            children: <Widget>[
              PostMakeOfferButton(post: post),
              CustomElevatedButton(
                title: 'book_visit'.tr(),
                bgColor: Colors.transparent,
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                isLoading: false,
                onTap: () {
                  AppNavigator.pushNamed(BookingScreen.routeName,
                      arguments: <String, dynamic>{'post': post});
                },
              ),
            ],
          ),
      ],
    );
  }
}
