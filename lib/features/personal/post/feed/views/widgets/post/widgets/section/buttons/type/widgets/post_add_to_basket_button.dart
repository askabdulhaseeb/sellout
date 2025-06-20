import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/dialogs/cart/add_to_cart_dialog.dart';
import '../../../../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../../../domain/params/add_to_cart_param.dart';
import '../../../../../../../../../domain/usecase/add_to_cart_usecase.dart';

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
    final BorderRadius borderRadius = BorderRadius.circular(8);
    final BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: borderRadius,
    );
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).disabledColor,
              ),
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  borderRadius: borderRadius,
                  onTap: () {
                    if (quantity == 1) return;
                    setState(() {
                      quantity--;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(4),
                    decoration: decoration,
                    child: Icon(
                      Icons.remove,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(quantity.toString(),
                      style: TextTheme.of(context).titleMedium),
                ),
                InkWell(
                  borderRadius: borderRadius,
                  onTap: () {
                    if (quantity == widget.post.quantity) return;
                    setState(() {
                      quantity++;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(4),
                    decoration: decoration,
                    child: Icon(
                      Icons.add,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 50,
            child: CustomElevatedButton(
              margin: const EdgeInsets.all(0),
              onTap: () async {
                try {
                  if (widget.post.sizeColors.isNotEmpty) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddToCartDialog(post: widget.post);
                      },
                    );
                  } else {
                    final AddToCartUsecase usecase =
                        AddToCartUsecase(locator());
                    final DataState<bool> result = await usecase(
                      AddToCartParam(post: widget.post, quantity: quantity),
                    );
                    if (result is DataSuccess) {
                      AppSnackBar.showSnackBar(
                        // ignore: use_build_context_synchronously
                        context,
                        'successfull_add_to_basket'.tr(),
                        backgroundColor: Colors.green,
                      );
                    } else {
                      AppLog.error(
                        result.exception?.message ?? 'AddToCartDialog',
                        name: 'post_add_to_basket_button.dart',
                        error: result.exception,
                      );
                      AppSnackBar.showSnackBar(
                        // ignore: use_build_context_synchronously
                        context,
                        result.exception?.message ?? 'something_wrong'.tr(),
                      );
                    }
                  }
                  //
                } catch (e) {
                  AppLog.error(
                    e.toString(),
                    name: 'PostAddToBasketButton.onTap - catch',
                    error: e,
                  );
                }
              },
              title: 'add_to_basket'.tr(),
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
        ),
      ],
    );
  }
}
