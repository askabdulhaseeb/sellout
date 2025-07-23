import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../domain/enum/radius_type.dart';
import '../../../../providers/marketplace_provider.dart';
import '../bottomsheets/filter_bottomsheet/filter_bottomsheet.dart';
import '../bottomsheets/location_radius_bottomsheet/location_radius_bottomsheet.dart';
import '../bottomsheets/sort_bottomsheet/sort_bottomsheet.dart';

class MarketPlaceHeaderButtons extends StatelessWidget {
  const MarketPlaceHeaderButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider pro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _HeaderButton(
              onPressed: () => showModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        const LocationRadiusBottomSheet(),
                  ),
              icon: CupertinoIcons.location_solid,
              label:
                  '${'location'.tr()}${pro.radiusType == RadiusType.local ? ' -  ${pro.selectedRadius.toInt()} km' : ''}'),
          const SizedBox(
            width: 4,
          ),
          _HeaderButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => const SortBottomSheet(),
            ),
            icon: CupertinoIcons.sort_down,
            label: 'sort',
          ),
          const SizedBox(
            width: 4,
          ),
          _HeaderButton(
            onPressed: () => showModalBottomSheet(
              showDragHandle: false,
              isDismissible: false,
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) =>
                  const MarketPlaceFilterBottomSheet(),
            ),
            icon: Icons.tune,
            label: 'filter',
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton(
      {required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? textStyle = theme.textTheme.bodySmall;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.primaryColor,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label.tr(),
        style: textStyle,
      ),
    );
  }
}
