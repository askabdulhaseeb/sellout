import 'package:flutter/material.dart';

import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';

class StartSellingList extends StatelessWidget {
  const StartSellingList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ListingType> list = ListingType.list;
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: list
          .map(
            (ListingType type) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .color!
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Theme.of(context).dividerColor,
                        radius: 18,
                        child: Icon(type.icon),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        type.code,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
