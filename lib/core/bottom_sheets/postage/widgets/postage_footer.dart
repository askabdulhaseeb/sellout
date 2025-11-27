import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../../features/personal/basket/views/providers/cart_provider.dart';

class PostageFooter extends StatelessWidget {
  const PostageFooter({
    required this.postage,
    required this.cartPro,
    required this.onApply,
    super.key,
  });

  final PostageDetailResponseEntity postage;
  final CartProvider cartPro;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr())),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onApply, child: Text('apply'.tr())),
        ],
      ),
    );
  }
}
