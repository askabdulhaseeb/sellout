import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../providers/marketplace_provider.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () {
              pro.resetLocationBottomsheet(context);
            },
            child: Text('cancel'.tr(),
                style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                    )),
          ),
          Text(
            'location'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: () async {
              await pro.loadPosts();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(
              'apply'.tr(),
              style: TextTheme.of(context).bodyMedium?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
