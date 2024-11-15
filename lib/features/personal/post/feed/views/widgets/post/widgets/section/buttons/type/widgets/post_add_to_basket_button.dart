import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../../core/dialogs/cart/add_to_cart_dialog.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';

class PostAddToBasketButton extends StatelessWidget {
  const PostAddToBasketButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onTap: () async {
        try {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddToCartDialog(
                post: post,
              );
            },
          );
          //
        } catch (e) {
          AppLog.error(
            e.toString(),
            name: 'PostAddToBasketButton.onTap - catch',
            error: e,
          );
        }
      },
      title: 'add-to-basket'.tr(),
      bgColor: Colors.transparent,
      border: Border.all(color: Theme.of(context).primaryColor),
      textColor: Theme.of(context).primaryColor,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      isLoading: false,
    );
  }
}
