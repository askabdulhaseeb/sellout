import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../providers/marketplace_provider.dart';

class MarketplaceChoiceChips extends StatefulWidget {
  const MarketplaceChoiceChips({super.key});

  @override
  State<MarketplaceChoiceChips> createState() => _MarketplaceChoiceChipsState();
}

class _MarketplaceChoiceChipsState extends State<MarketplaceChoiceChips> {
  String? selectedCid;

  @override
  void initState() {
    super.initState();
    selectedCid = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketPlaceProvider>().loadChipsPosts('');
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Gather all cids from ListingType enums
    final Set<String> allCids = <String>{
      'all',
      for (final ListingType type in ListingType.values) ...type.cids
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(left: 14),
        height: 50,
        child: Row(
          children: allCids.map((String cid) {
            final bool isSelected =
                selectedCid == cid || (cid == 'all' && selectedCid == null);
            final String label = cid == 'all' ? 'all'.tr() : cid.tr();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                showCheckmark: false,
                label: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onSelected: (_) {
                  setState(() {
                    selectedCid = cid == 'all' ? null : cid;
                  });
                  context
                      .read<MarketPlaceProvider>()
                      .loadChipsPosts(cid == 'all' ? '' : cid);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
