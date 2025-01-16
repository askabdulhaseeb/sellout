import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelloutBankGuranterWidget extends StatelessWidget {
  const SelloutBankGuranterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'shop_with_confidence',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 6),
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
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ).tr(),
                  Opacity(
                    opacity: 0.7,
                    child: const Text(
                      'get_the_items_you_ordered',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ).tr(),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
