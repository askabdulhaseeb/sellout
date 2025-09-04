import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../order/view/screens/your_order_screen.dart';
import '../../../../../domain/enum/radius_type.dart';
import '../../../../providers/marketplace_provider.dart';
import '../../../../screens/pages/buy_again_screen.dart';
import '../../../../screens/pages/saved_posts_page.dart';
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
          spacing: 4,
          children: <Widget>[
            _HeaderButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<LocationRadiusBottomSheet>(
                      builder: (BuildContext context) =>
                          LocationRadiusBottomSheet(
                        initialLocation: pro.selectedLocation,
                        initialLatLng: pro.selectedlatlng,
                        initialRadius: pro.selectedRadius,
                        initialRadiusType: pro.radiusType,
                        onApply: () => pro.locationSheetApplyButton(
                          context,
                        ),
                        onReset: () => pro.resetLocationBottomsheet(),
                        onUpdateLocation: (RadiusType radiusType, double radius,
                                LatLng latlng, LocationEntity? location) =>
                            pro.updateLocationSheet(
                                latlng, location, radiusType, radius),
                      ),
                    )),
                icon: AppStrings.selloutMarketplaceLocationIcon,
                label: pro.selectedLocation == null
                    ? 'location'.tr()
                    : '${pro.selectedLocation?.title}'),
            if (pro.queryController.text.isEmpty)
              _HeaderButton(
                onPressed: () =>
                    Navigator.pushNamed(context, YourOrdersScreen.routeName),
                icon: null,
                label: 'your_orders'.tr(),
              ),
            if (pro.queryController.text.isEmpty)
              _HeaderButton(
                onPressed: () =>
                    Navigator.pushNamed(context, SavedPostsPage.routeName),
                icon: null,
                label: 'saved'.tr(),
              ),
            if (pro.queryController.text.isEmpty)
              _HeaderButton(
                onPressed: () =>
                    Navigator.pushNamed(context, BuyAgainScreen.routeName),
                icon: null,
                label: 'buy_again'.tr(),
              ),
            if (pro.queryController.text.isNotEmpty)
              _HeaderButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => const SortBottomSheet(),
                ),
                icon: AppStrings.selloutMarketplaceSortIcon,
                label: 'sort'.tr(),
              ),
            if (pro.queryController.text.isNotEmpty)
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
                label: 'filter'.tr(),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String? icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? textStyle = theme.textTheme.labelSmall
        ?.copyWith(fontWeight: FontWeight.w400, fontSize: 10);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: theme.colorScheme.outlineVariant, width: 1),
          ),
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null)
                CustomSvgIcon(
                  assetPath: icon!,
                  size: 14,
                  color: AppTheme.primaryColor,
                ),
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  label,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
