import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../listing_form/views/providers/add_listing_form_provider.dart';
import '../../../listing_form/views/screens/add_listing_form_screen.dart';

class StartSellingList extends StatelessWidget {
  const StartSellingList({
    required this.searchQuery,
    super.key,
  });

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final List<ListingType> list = ListingType.list;

    final List<ListingType> filteredList = list.where((ListingType type) {
      final String code = type.code.toLowerCase();
      return code.contains(searchQuery.toLowerCase());
    }).toList();

    return ListView(
      primary: false,
      shrinkWrap: true,
      children: filteredList
          .map(
            (ListingType type) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: () {
                  final AddListingFormProvider pro =
                      Provider.of<AddListingFormProvider>(
                    context,
                    listen: false,
                  );
                  pro.setListingType(type);
                  Navigator.of(context)
                      .pushNamed(AddListingFormScreen.routeName);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
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
