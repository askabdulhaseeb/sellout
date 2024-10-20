import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';

class PostAddToBasketButton extends StatelessWidget {
  const PostAddToBasketButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onTap: () {},
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
