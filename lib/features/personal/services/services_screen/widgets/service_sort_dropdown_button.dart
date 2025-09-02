import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/params/service_sort_options.dart';
import '../providers/services_page_provider.dart';

class SortButtonWithBottomSheet extends StatefulWidget {
  const SortButtonWithBottomSheet({super.key});

  @override
  State<SortButtonWithBottomSheet> createState() =>
      _SortButtonWithBottomSheetState();
}

class _SortButtonWithBottomSheetState extends State<SortButtonWithBottomSheet> {
  ServiceSortOption? selectedOption;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showSortBottomSheet,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.outlineVariant,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.sort, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(
            'sort'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) => const SortBottomSheet(),
    );
  }
}

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

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
