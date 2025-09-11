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

    // Filter by translated text instead of code
    final List<ListingType> filteredList = list.where((ListingType type) {
      final String translated = type.code.tr().toLowerCase(); // translate here
      return translated.contains(searchQuery.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      children: filteredList
          .map(
            (ListingType type) => InkWell(
              onTap: () {
                final AddListingFormProvider pro =
                    Provider.of<AddListingFormProvider>(
                  context,
                  listen: false,
                );
                pro.setListingType(type);
                Navigator.of(context).pushNamed(AddListingFormScreen.routeName);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).dividerColor,
                      ),
                      child: Image.asset(
                        type.icon,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      type.code.tr(), // show translated text
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
