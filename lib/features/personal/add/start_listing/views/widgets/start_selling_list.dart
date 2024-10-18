import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../listing_form/views/providers/add_listing_form_provider.dart';
import '../../../listing_form/views/screens/add_listing_form_screen.dart';

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
                onTap: () {
                  Provider.of<AddListingFormProvider>(context, listen: false)
                      .setListingType(type);
                  Navigator.of(context)
                      .pushNamed(AddListingFormScreen.routeName);
                },
                child: ShadowContainer(
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
