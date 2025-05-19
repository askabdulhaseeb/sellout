import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/sort_enums.dart';
import '../providers/marketplace_provider.dart';
import 'bottomsheets/filter_bottomsheet.dart';
import 'bottomsheets/location_bottomsheet.dart';
import 'bottomsheets/sort_bottomsheet.dart';

class MarketPlaceFilterButtons extends StatelessWidget {
  const MarketPlaceFilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _LocationButton(),
          _SortButton(),
          _FilterButton(),
        ],
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton();

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider pro = Provider.of<MarketPlaceProvider>(context);
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color outlineColor = Theme.of(context).colorScheme.outline;

    return InkWell(
      onTap: () => showBottomSheet(
        context: context,
        builder: (BuildContext context) => const LocationRadiusBottomSheet(),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(width: 1, color: outlineColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Icon(CupertinoIcons.location_solid, size: 18, color: primaryColor),
            const SizedBox(width: 5),
            Text(
              '${'location'.tr()} - ${pro.selectedRadius} Km',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider pro = Provider.of<MarketPlaceProvider>(context);
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color outlineColor = Theme.of(context).colorScheme.outline;

    return InkWell(
      onTap: () => showBottomSheet(
        context: context,
        builder: (BuildContext context) => SortBottomSheet(
          onSortSelected: (SortOption option) {
            pro.setSortOption(option);
          },
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(width: 1, color: outlineColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Icon(CupertinoIcons.sort_down, size: 18, color: primaryColor),
            const SizedBox(width: 5),
            Text('sort'.tr(), style: textStyle),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color outlineColor = Theme.of(context).colorScheme.outline;

    return InkWell(
      onTap: () => showBottomSheet(
        context: context,
        builder: (BuildContext context) => const FilterBottomSheet(),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(width: 1, color: outlineColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.tune, size: 18, color: primaryColor),
            const SizedBox(width: 5),
            Text('filter'.tr(), style: textStyle),
          ],
        ),
      ),
    );
  }
}
