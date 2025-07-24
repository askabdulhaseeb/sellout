import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../enums/customer_review_type.dart';
import '../../../../../../providers/marketplace_provider.dart';

class FilterSheetCustomerReviewTile extends StatelessWidget {
  const FilterSheetCustomerReviewTile({super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          'customer_review'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Consumer<MarketPlaceProvider>(
          builder: (BuildContext context, MarketPlaceProvider pro, _) =>
              DropdownButtonFormField<ReviewFilterParam>(
            value: ReviewFilterParamExtension.fromJson(pro.rating),
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
                  param.text.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }).toList(),
            onChanged: (ReviewFilterParam? newValue) {
              pro.setRating(newValue?.jsonValue);
            },
          ),
        ));
  }
}
