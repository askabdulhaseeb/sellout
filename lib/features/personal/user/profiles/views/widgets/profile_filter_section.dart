import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../data/models/user_model.dart';
import '../providers/profile_provider.dart';
import 'gridview_filter_bottomsheets/store_category_bottomsheet.dart';
import 'gridview_filter_bottomsheets/store_filter_bottomsheet.dart';

class ProfileFilterSection extends StatelessWidget {
  const ProfileFilterSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pro, Widget? child) =>
          Row(
        spacing: 4,
        children: <Widget>[
          Flexible(
            child: CustomTextFormField(
              dense: true,
              contentPadding: const EdgeInsets.all(4),
              fieldPadding: const EdgeInsets.all(0),
              controller: pro.queryController,
              hint: 'search'.tr(),
              style: textTheme.bodySmall,
              prefix: const CustomSvgIcon(
                assetPath: AppStrings.selloutSearchIcon,
                size: 16,
              ),
            ),
          ),
          Expanded(
              child: CustomFilterButton(
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        showDragHandle: false,
                        isDismissible: false,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const StoreCategoryBottomSheet(),
                      ),
                  label: 'category'.tr(),
                  icon: Icons.tune)),
          Expanded(
              child: CustomFilterButton(
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        showDragHandle: false,
                        isDismissible: false,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const StoreFilterBottomSheet(),
                      ),
                  label: 'filter'.tr(),
                  icon: Icons.tune)),
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
    super.key,
  });
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

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
            Icon(
              icon,
              size: 12,
            ),
            Text(
              label,
              style: textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
