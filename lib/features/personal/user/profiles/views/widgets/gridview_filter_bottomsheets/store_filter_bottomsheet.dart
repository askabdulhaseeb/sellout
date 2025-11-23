import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../marketplace/views/enums/sort_enums.dart';
import '../../providers/profile_provider.dart';

class StoreFilterBottomSheet extends StatelessWidget {
  const StoreFilterBottomSheet({required this.isStore, super.key});
  final bool isStore;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: false,
      enableDrag: false,
      onClosing: () {},
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: <Widget>[
              StoreFilterSheetHeaderSection(
                isStore: isStore,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    children: <Widget>[
                      StoreFilterSheetCustomerReviewTile(
                        isStore: isStore,
                      ),
                      ExpandablePriceRangeTile(
                        isStore: isStore,
                      ),
                      if (isStore == true)
                        StoreFilterSheetConditionTile(
                          isStore: isStore,
                        ),
                      if (isStore == true)
                        StoreFilterSheetDeliveryTypeTile(
                          isStore: isStore,
                        ),
                    ],
                  ),
                ),
              ),
              StoreFilterSheetApplyButton(
                isStore: isStore,
              )
            ],
          ),
        );
      },
    );
  }
}

class StoreFilterSheetCustomerReviewTile extends StatelessWidget {
  const StoreFilterSheetCustomerReviewTile({required this.isStore, super.key});
  final bool isStore;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          'sort_by'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider pro, _) =>
              DropdownButtonFormField<SortOption>(
            value: isStore ? pro.storeSort : pro.viewingSort,
            isExpanded: true,
            hint: Text(
              'sort_by_choice'.tr(),
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
            items: SortOption.values.map((SortOption param) {
              return DropdownMenuItem<SortOption>(
                value: param,
                child: Text(
                  param.code.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }).toList(),
            onChanged: (SortOption? newValue) {
              if (isStore) {
                pro.setStoreSort(newValue);
              } else {
                pro.setViewingSort(newValue);
              }
            },
          ),
        ));
  }
}

class ExpandablePriceRangeTile extends StatefulWidget {
  const ExpandablePriceRangeTile({required this.isStore, super.key});
  final bool isStore;

  @override
  State<ExpandablePriceRangeTile> createState() =>
      _ExpandablePriceRangeTileState();
}

class _ExpandablePriceRangeTileState extends State<ExpandablePriceRangeTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider marketPro, _) {
        final TextEditingController minPriceController = widget.isStore
            ? marketPro.storeMinPriceController
            : marketPro.viewingMinPriceController;

        final TextEditingController maxPriceController = widget.isStore
            ? marketPro.storeMaxPriceController
            : marketPro.viewingMaxPriceController;

        return Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              title: Text(
                'price'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                !_isExpanded ? 'select_price_range'.tr() : '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomTextFormField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        labelText: 'min_price'.tr(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        labelText: 'max_price'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isExpanded) const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class StoreFilterSheetConditionTile extends StatelessWidget {
  const StoreFilterSheetConditionTile({required this.isStore, super.key});
  final bool isStore;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider pro, Widget? child) {
      return ListTile(
        title: Text(
          'condition'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: DropdownButtonFormField<ConditionType>(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.outline,
          ),
          value: isStore
              ? pro.storeSelectedConditionType
              : pro.viewingSelectedConditionType,
          isExpanded: true,
          dropdownColor: Theme.of(context).cardColor,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          hint: Text(
            'select_condition'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          items: ConditionType.values.map((ConditionType type) {
            return DropdownMenuItem<ConditionType>(
              value: type,
              child: Text(
                type.code.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (ConditionType? newValue) {
            if (isStore) {
              pro.setStoreConditionType(newValue);
            } else {
              pro.setViewingConditionType(newValue);
            }
          },
        ),
      );
    });
  }
}

class StoreFilterSheetDeliveryTypeTile extends StatelessWidget {
  final bool isStore;

  const StoreFilterSheetDeliveryTypeTile({required this.isStore, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider pro, Widget? child) {
      return ListTile(
        title: Text(
          'delivery_type'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: DropdownButtonFormField<DeliveryType>(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.outline,
          ),
          value: isStore
              ? pro.storeSelectedDeliveryType
              : pro.viewingSelectedDeliveryType,
          isExpanded: true,
          hint: Text(
            'select_delivery_type'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          items: DeliveryType.values.map((DeliveryType type) {
            return DropdownMenuItem<DeliveryType>(
              value: type,
              child: Text(
                type.code.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (DeliveryType? newValue) {
            if (isStore) {
              pro.setStoreDeliveryType(newValue);
            } else {
              pro.setViewingDeliveryType(newValue);
            }
          },
        ),
      );
    });
  }
}

class StoreFilterSheetHeaderSection extends StatelessWidget {
  const StoreFilterSheetHeaderSection({
    required this.isStore,
    super.key,
  });
  final bool isStore;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pro, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CloseButton(onPressed: () {
            Navigator.pop(context);
          }),
          Text(
            'filter'.tr(),
            style: TextTheme.of(context)
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: () {
              if (isStore) {
                pro.storefilterSheetResetButton();
              } else {
                pro.viewingfilterSheetResetButton();
              }
            },
            child: Text(
              'reset'.tr(),
              style: TextTheme.of(context)
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class StoreFilterSheetApplyButton extends StatelessWidget {
  // <-- control variable

  const StoreFilterSheetApplyButton({
    required this.isStore,
    super.key,
  });
  final bool isStore;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pro, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomElevatedButton(
          onTap: () {
            if (isStore) {
              pro.storefilterSheetApplyButton(); // Apply store filter
            } else {
              pro.viewingfilterSheetApplyButton(); // Apply viewing filter (example)
            }
            Navigator.pop(context);
          },
          title: 'apply'.tr(),
          isLoading: pro.isLoading,
        ),
      ),
    );
  }
}
