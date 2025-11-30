import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../marketplace/views/enums/customer_review_type.dart';
import '../../../../providers/services_page_provider.dart';

class ServiceFilterSheetCustomerReviewTile extends StatelessWidget {
  const ServiceFilterSheetCustomerReviewTile({super.key});
  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider provider =
        Provider.of<ServicesPageProvider>(context);
    return ListTile(
      title: Text(
        'customer_review'.tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: DropdownButtonFormField<ReviewFilterParam>(
        initialValue: ReviewFilterParamExtension.fromJson(provider.rating),
        isExpanded: true,
        hint: Text(
          'select_customer_review'.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.outline,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: ReviewFilterParam.values.map((ReviewFilterParam param) {
          return DropdownMenuItem<ReviewFilterParam>(
            value: param,
            child: Text(
              param.text.tr(), // show '5 Stars', etc. with localization
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          );
        }).toList(),
        onChanged: (ReviewFilterParam? newValue) {
          provider.setRating(newValue?.jsonValue); // ✅ fixed here
        },
      ),
    );
  }
}
