import 'package:flutter/material.dart';
import 'widgets/market_choice_chip_grid.dart';
import 'widgets/market_choice_chips.dart';

class MarketChoiceChipSection extends StatefulWidget {
  const MarketChoiceChipSection({super.key});
  @override
  State<MarketChoiceChipSection> createState() =>
      _MarketChoiceChipSectionState();
}

class _MarketChoiceChipSectionState extends State<MarketChoiceChipSection> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        MarketplaceChoiceChips(),
        MarketplaceChoiceGridWidget()
      ],
    );
  }
}
