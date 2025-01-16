import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';

class PostBuyNowButto extends StatelessWidget {
  const PostBuyNowButto({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onTap: () {},
      title: 'buy_now'.tr(),
      isLoading: false,
    );
  }
}
