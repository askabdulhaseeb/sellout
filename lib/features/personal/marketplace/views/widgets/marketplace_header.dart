import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'marketplace_search_field.dart';

class MarketPlaceHeader extends StatelessWidget {
  const MarketPlaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const MarketplaceSearchField(),
              const SizedBox(
                width: 4,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(CupertinoIcons.eye_slash,
                    color: Theme.of(context).colorScheme.onSurface, size: 26),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
