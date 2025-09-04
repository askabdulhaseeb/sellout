import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/params/service_sort_options.dart';
import '../providers/services_page_provider.dart';

class ExploreServicesSortBottomSheet extends StatelessWidget {
  const ExploreServicesSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider provider =
        Provider.of<ServicesPageProvider>(context);

    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              'sort'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
          ),
          const Divider(),
          ...ServiceSortOption.values.map((ServiceSortOption option) {
            final bool isSelected = provider.selectedSortOption == option;
            return ListTile(
              leading: buildLeadingIcon(context, isSelected),
              title: Text(option.code.tr()),
              onTap: () {
                provider.setSortOption(option);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget buildLeadingIcon(BuildContext context, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: AppTheme.primaryColor, size: 18)
          : null,
    );
  }
}
