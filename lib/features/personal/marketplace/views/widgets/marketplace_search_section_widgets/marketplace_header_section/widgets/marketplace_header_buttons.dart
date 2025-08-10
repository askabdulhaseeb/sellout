import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../domain/enum/radius_type.dart';
import '../../../../providers/marketplace_provider.dart';
import '../bottomsheets/filter_bottomsheet/filter_bottomsheet.dart';
import '../bottomsheets/location_radius_bottomsheet/location_radius_bottomsheet.dart';
import '../bottomsheets/sort_bottomsheet/sort_bottomsheet.dart';

class MarketPlaceHeaderButtons extends StatelessWidget {
  const MarketPlaceHeaderButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          SizedBox(
        height: 40,
        child: Row(
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
                icon: AppStrings.selloutMarketplaceLocationIcon,
                label: pro.radiusType == RadiusType.worldwide
                    ? 'location'.tr()
                    : '${pro.selectedRadius.toInt()} km'),
            const SizedBox(
              width: 4,
            ),
            _HeaderButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => const SortBottomSheet(),
              ),
              icon: AppStrings.selloutMarketplaceSortIcon,
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
              icon: AppStrings.selloutMarketplaceFilterIcon,
              label: 'filter',
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton(
      {required this.icon, required this.label, required this.onPressed});
  final String icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? textStyle =
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400);

    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        icon: CustomSvgIcon(assetPath: icon, size: 14),
        label: Text(
          label.tr(),
          style: textStyle,
        ),
      ),
    );
  }
}
