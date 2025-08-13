import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../data/models/user_model.dart';
import '../enums/profile_page_tab_type.dart';
import '../providers/profile_provider.dart';
import 'gridview_filter_bottomsheets/store_category_bottomsheet.dart';
import 'gridview_filter_bottomsheets/store_filter_bottomsheet.dart';
import 'dart:async';

class ProfileFilterSection extends StatelessWidget {
  const ProfileFilterSection(
      {required this.user, required this.pageType, super.key});
  final UserEntity? user;
  final ProfilePageTabType? pageType;

  @override
  Widget build(BuildContext context) {
    final bool isStore = (pageType!.code == ProfilePageTabType.store.code);
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pro, Widget? child) =>
          Row(
        spacing: 4,
        children: <Widget>[
          Flexible(child: ProfilePostSearchField(isStore: isStore)),
          Expanded(
              child: CustomFilterButton(
                  iconFirst: false,
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) =>
                            StoreCategoryBottomSheet(
                          isStore: isStore,
                        ),
                      ),
                  label: 'category'.tr(),
                  icon: AppStrings.selloutDropDownIcon)),
          Expanded(
              child: CustomFilterButton(
                  iconFirst: true,
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        showDragHandle: false,
                        isDismissible: false,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            StoreFilterBottomSheet(
                          isStore: isStore,
                        ),
                      ),
                  label: 'filter'.tr(),
                  icon: AppStrings.selloutFilterIcon)),
        ],
      ),
    );
  }
}

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.iconFirst = true,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final String icon;
  final bool iconFirst;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorScheme.of(context).outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (iconFirst) CustomSvgIcon(assetPath: icon, size: 12),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: ColorScheme.of(context).outline,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!iconFirst) CustomSvgIcon(assetPath: icon, size: 12),
            ]),
      ),
    );
  }
}

class ProfilePostSearchField extends StatefulWidget {
  const ProfilePostSearchField({
    required this.isStore,
    super.key,
  });
  final bool isStore;

  @override
  State<ProfilePostSearchField> createState() => _ProfilePostSearchFieldState();
}

class _ProfilePostSearchFieldState extends State<ProfilePostSearchField> {
  Timer? _debounce;

  void _onSearchChanged(ProfileProvider pro, String value) {
    // Debounce to prevent too many API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.isStore) {
        pro.loadStorePosts(); // ← Add query to API if needed
      } else {
        pro.loadViewingPosts(); // ← Add query to API if needed
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro =
        Provider.of<ProfileProvider>(context, listen: false);
    final TextEditingController controller =
        widget.isStore ? pro.storeQueryController : pro.viewingQueryController;

    return CustomTextFormField(
      dense: true,
      contentPadding: const EdgeInsets.all(4),
      fieldPadding: const EdgeInsets.all(0),
      controller: controller,
      hint: 'search'.tr(),
      style: TextTheme.of(context).bodyMedium,
      prefix: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CustomSvgIcon(
            assetPath: AppStrings.selloutSearchIcon,
            size: 16,
          ),
        ],
      ),
      onChanged: (String value) => _onSearchChanged(pro, value),
    );
  }
}
