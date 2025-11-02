import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import 'cart_screens/personal_cart_cart_item_list.dart';

class BasketItemListPage extends StatelessWidget {
  const BasketItemListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        const PersonalCartItemList(), //is a listviewbuilder in a sizedbox
        Container(
          //need to be attached to bottom
          padding: const EdgeInsets.all(16),
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InDevMode(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('delivery'.tr()), const Text('free')],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'subtotal'.tr(),
                    style: TextTheme.of(context)
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Text('j'),
                ],
              ),
              CustomElevatedButton(
                  title: 'proceed_to_checkout'.tr(),
                  isLoading: false,
                  onTap: () {})
            ],
          ),
        ),
      ],
    );
  }
}
