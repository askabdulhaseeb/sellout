import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import 'bottomsheets/location_radius_bottomsheet/location_radius_bottomsheet.dart';

class MarketPlaceHeaderButtons extends StatelessWidget {
  const MarketPlaceHeaderButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _HeaderButton(
            onPressed: () => showBottomSheet(
              context: context,
              builder: (BuildContext context) => LocationRadiusBottomSheet(),
            ),
            icon: CupertinoIcons.location_solid,
            label: 'location',
          ),
          const SizedBox(
            width: 4,
          ),
          _HeaderButton(
            onPressed: () {},
            icon: CupertinoIcons.sort_down,
            label: 'sort',
          ),
          const SizedBox(
            width: 4,
          ),
          _HeaderButton(
            onPressed: () {},
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
    final TextStyle? textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.primaryColor,
        side: BorderSide(color: theme.colorScheme.outline),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
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
