import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../enums/sort_enums.dart';
import '../../../../../providers/marketplace_provider.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider provider =
        Provider.of<MarketPlaceProvider>(context);
    final SortOption? selectedOption = provider.selectedSortOption;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        backgroundBlendMode: BlendMode.color,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Text(
              'sort'.tr(),
              style: TextTheme.of(context).titleLarge?.copyWith(fontSize: 14),
            ),
          ),
          const Divider(),
          ...SortOption.values.map((SortOption option) {
            final bool isSelected = selectedOption == option;
            return ListTile(
              leading: _buildLeadingIcon(context, isSelected),
              title: Text(option.code.tr()),
              onTap: () {
                provider.filterSortedPosts(option);
                Navigator.pop(context); // close sheet on selection
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor
              : ColorScheme.of(context).outline,
          width: 2,
        ),
        color:
            isSelected ? ColorScheme.of(context).surface : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: AppTheme.primaryColor, size: 18)
          : null,
    );
  }
}
