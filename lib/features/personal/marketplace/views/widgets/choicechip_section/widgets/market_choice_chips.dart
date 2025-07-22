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
  String? selectedJson;

  @override
  void initState() {
    super.initState();
    selectedJson = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MarketPlaceProvider>(context, listen: false)
          .choiceChipsCategory('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (_, __, ___) {
        final List<String?> jsons = <String?>[
          null,
          ...ListingType.values.map((ListingType e) => e.json)
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.only(left: 14),
            height: 50,
            child: Row(
              children: jsons.map((String? json) {
                final bool isSelected = selectedJson == json;
                final String label = json?.tr() ?? 'all'.tr();
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
                        selectedJson = json;
                      });
                      context
                          .read<MarketPlaceProvider>()
                          .choiceChipsCategory(json);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
