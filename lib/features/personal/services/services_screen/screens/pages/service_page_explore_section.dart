import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../marketplace/domain/enum/radius_type.dart';
import '../../../../marketplace/views/widgets/marketplace_search_section_widgets/marketplace_header_section/bottomsheets/location_radius_bottomsheet/location_radius_bottomsheet.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/bottomsheets/services_filter_bottomsheet/services_filter_bottomsheet.dart';
import '../../widgets/explore/service_categories_section/services_page_explore_categories_section.dart';
import '../../widgets/explore/services_page_explore_search_results_section.dart';
import '../../widgets/explore/services_page_explore_searching_section.dart';
import '../../widgets/service_sort_dropdown_button.dart';

class ServicePageExploreSection extends StatefulWidget {
  const ServicePageExploreSection({super.key});

  @override
  State<ServicePageExploreSection> createState() =>
      _ServicePageExploreSectionState();
}

class _ServicePageExploreSectionState extends State<ServicePageExploreSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ServicesPageExploreSearchingSection(),
            if (pro.search.text.isNotEmpty)
              Row(
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
                              onUpdateLocation: (RadiusType radiusType,
                                      double radius,
                                      LatLng latlng,
                                      LocationEntity? location) =>
                                  pro.updateLocationSheet(
                                      latlng, location, radiusType, radius),
                            ),
                          )),
                      icon: AppStrings.selloutMarketplaceLocationIcon,
                      label: pro.selectedLocation == null
                          ? 'location'.tr()
                          : '${pro.selectedLocation?.title}'),
                  _HeaderButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) =>
                          const ExploreServicesSortBottomSheet(),
                    ),
                    icon: AppStrings.selloutMarketplaceSortIcon,
                    label: 'sort'.tr(),
                  ),
                  _HeaderButton(
                    onPressed: () => showModalBottomSheet(
                      showDragHandle: false,
                      isDismissible: false,
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) =>
                          const ServicesExploreFilterBottomSheet(),
                    ),
                    icon: AppStrings.selloutMarketplaceFilterIcon,
                    label: 'filter'.tr(),
                  ),
                ],
              ),
            if (pro.search.text.isEmpty)
              const ServicesPageExploreCategoriesSection(),
            const SizedBox(
              height: 6,
            ),
            if (pro.search.text.isNotEmpty) const ServiceSearchResults()
          ],
        );
      },
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
