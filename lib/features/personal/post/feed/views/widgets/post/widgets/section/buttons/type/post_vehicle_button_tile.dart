import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../book_visit/view/provider/visiting_provider.dart';
import '../../../../../../../../../book_visit/view/screens/view_booking_screen.dart';
import '../../../../../../../../domain/entities/post_entity.dart';
import 'widgets/post_make_offer_button.dart';

class PostVehicleButtonTile extends StatelessWidget {
  const PostVehicleButtonTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final BookingProvider pro =
        Provider.of<BookingProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        if (post.acceptOffers == false)
          CustomElevatedButton(
            title: 'book_visit'.tr(),
            isLoading: false,
            onTap: () {
              pro.disposed();
              Navigator.pushNamed(context, BookingScreen.routeName,
                  arguments: <String, dynamic>{'post': post});
            },
          ),
        if (post.acceptOffers == true)
          Row(
            children: <Widget>[
              Expanded(child: PostMakeOfferButton(post: post)),
              const SizedBox(width: 12),
              Expanded(
                child: CustomElevatedButton(
                  title: 'book_visit'.tr(),
                  bgColor: Colors.transparent,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  isLoading: false,
                  onTap: () {
                    pro.disposed();
                    Navigator.pushNamed(context, BookingScreen.routeName,
                        arguments: <String, dynamic>{'post': post});
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
