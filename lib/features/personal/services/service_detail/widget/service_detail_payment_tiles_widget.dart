import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utilities/app_string.dart';
import '../../../post/post_detail/views/widgets/post_detail_postage_return_section.dart';

class SeviceDetailPaymentTilesWidget extends StatelessWidget {
  const SeviceDetailPaymentTilesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: <Widget>[
          PostDetailPaymentTile(image: AppStrings.visa),
          PostDetailPaymentTile(image: AppStrings.paypal),
          PostDetailPaymentTile(image: AppStrings.amex, bgColor: Colors.blue),
          PostDetailPaymentTile(image: AppStrings.applePayBlack),
          PostDetailPaymentTile(image: AppStrings.dinersClub),
          PostDetailPaymentTile(image: AppStrings.mastercard),
        ],
      ),
    );
  }
}
