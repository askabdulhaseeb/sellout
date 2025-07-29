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
        return SizedBox(
          height: 40, // Ensures consistent height for chips
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: jsons.length,
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemBuilder: (_, int index) {
              final String? json = jsons[index];
              final bool isSelected = selectedJson == json;
              final String label = json?.tr() ?? 'all'.tr();

              return ChoiceChip(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                showCheckmark: false,
                label: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                  context.read<MarketPlaceProvider>().choiceChipsCategory(json);
                },
              );
            },
          ),
        );
      },
    );
  }
}
