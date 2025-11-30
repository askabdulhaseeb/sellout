import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../providers/services_page_provider.dart';

class FilterSheetMobileServiceTile extends StatelessWidget {
  const FilterSheetMobileServiceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return ListTile(
          title: Text(
            'mobile_service'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: DropdownButtonFormField<bool>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorScheme.of(context).outline,
            ),
            initialValue: pro.selectedIsMobileService,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            hint: Text(
              'select_item'.tr(), // e.g. "Select Yes or No"
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ColorScheme.of(context).outline),
            ),
            items: <DropdownMenuItem<bool>>[
              DropdownMenuItem<bool>(
                value: true,
                child: Text(
                  'yes'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Text(
                  'no'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            ],
            onChanged: (bool? newValue) {
              pro.setSelectedIsMobileService(newValue);
            },
          ),
        );
      },
    );
  }
}
