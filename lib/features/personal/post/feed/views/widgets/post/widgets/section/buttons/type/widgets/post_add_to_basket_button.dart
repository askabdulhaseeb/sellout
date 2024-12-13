import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../../core/dialogs/cart/add_to_cart_dialog.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';

class PostAddToBasketButton extends StatefulWidget {
  const PostAddToBasketButton({required this.post, super.key});
  final PostEntity post;

  @override
  State<PostAddToBasketButton> createState() => _PostAddToBasketButtonState();
}

class _PostAddToBasketButtonState extends State<PostAddToBasketButton> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomIconButton(
                icon: Icons.remove,
                onPressed: () {
                  if (quantity == 1) return;
                  setState(() {
                    quantity--;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomIconButton(
                icon: Icons.add,
                onPressed: () {
                  if (quantity == widget.post.quantity) return;
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomElevatedButton(
            onTap: () async {
              try {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddToCartDialog(
                      post: widget.post,
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
          ),
        ),
      ],
    );
  }
}
