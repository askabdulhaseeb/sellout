import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../cart/views/providers/cart_provider.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';

class PostBuyNowButto extends StatelessWidget {
  const PostBuyNowButto({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final CartProvider Cartpro =
        Provider.of<CartProvider>(context, listen: false);
    return CustomElevatedButton(
      onTap: () async {
        Cartpro.getBillingDetails();
      },
      title: 'buy_now'.tr(),
      isLoading: false,
    );
  }
}
