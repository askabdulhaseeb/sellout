import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/marketplace_provider.dart';
import '../../market_private_search_dialog.dart';
import 'widgets/marketplace_header_buttons.dart';
import '../marketplace_search_field.dart';

class MarketPlaceHeader extends StatelessWidget {
  const MarketPlaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              const MarketplaceSearchField(),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => showPrivateSearchDialog(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.eye_slash,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          Consumer<MarketPlaceProvider>(
            builder:
                (BuildContext context, MarketPlaceProvider pro, Widget? child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(
                        color: ColorScheme.of(
                          context,
                        ).onSurface.withValues(alpha: 0.2),
                      ),
                      const MarketPlaceHeaderButtons(),
                      if (pro.queryController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            '${'showing_result_for'.tr()} "${pro.queryController.text}"',
                          ),
                        ),
                    ],
                  );
                },
          ),
        ],
      ),
    );
  }
}
