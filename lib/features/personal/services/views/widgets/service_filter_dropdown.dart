import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/params/service_sort_options.dart';
import 'bottomsheets/services_filter_bottomsheet/filter_bottomsheet.dart';

class FillterButtonWithBottomSheet extends StatefulWidget {
  const FillterButtonWithBottomSheet({super.key});

  @override
  State<FillterButtonWithBottomSheet> createState() =>
      _FillterButtonWithBottomSheetState();
}

class _FillterButtonWithBottomSheetState
    extends State<FillterButtonWithBottomSheet> {
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
            'filter'.tr(),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (BuildContext context) =>
          const ServicesExploreFilterBottomSheet(),
    );
  }
}
