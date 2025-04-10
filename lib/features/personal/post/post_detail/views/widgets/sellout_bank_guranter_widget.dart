import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utilities/app_string.dart';
import 'post_detail_postage_return_section.dart';

class SelloutBankGuranterWidget extends StatelessWidget {
  const SelloutBankGuranterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // const Text(
          //   'shop_with_confidence',
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          // ).tr(),
          PostDetailTile(
            title: 'payments',
            trailing: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: <Widget>[
                PostDetailPaymentTile(image: AppStrings.visa),
                PostDetailPaymentTile(image: AppStrings.paypal),
                PostDetailPaymentTile(
                    image: AppStrings.amex, bgColor: Colors.blue),
                PostDetailPaymentTile(image: AppStrings.applePayBlack),
                PostDetailPaymentTile(image: AppStrings.dinersClub),
                PostDetailPaymentTile(image: AppStrings.mastercard),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(
                Icons.monetization_on_outlined,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'sellout_money_bank_guarantee',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ).tr(),
                    Opacity(
                      opacity: 0.7,
                      child: const Text(
                        'get_the_items_you_ordered',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
