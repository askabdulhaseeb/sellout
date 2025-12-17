import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../marketplace/views/enums/sort_enums.dart';

class StoreFilterBottomSheet extends StatefulWidget {
  const StoreFilterBottomSheet({
    required this.sort,
    required this.onSortChanged,
    required this.minPriceController,
    required this.maxPriceController,
    required this.onReset,
    required this.onApply,
    required this.isLoading,
    this.showStoreFields = false,
    this.selectedConditionType,
    this.onConditionChanged,
    this.selectedDeliveryType,
    this.onDeliveryTypeChanged,
    super.key,
  });

  final SortOption? sort;
  final ValueChanged<SortOption?> onSortChanged;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final bool isLoading;

  /// When true, shows store-only fields like condition and delivery type.
  final bool showStoreFields;
  final ConditionType? selectedConditionType;
  final ValueChanged<ConditionType?>? onConditionChanged;
  final DeliveryType? selectedDeliveryType;
  final ValueChanged<DeliveryType?>? onDeliveryTypeChanged;

  @override
  State<StoreFilterBottomSheet> createState() => _StoreFilterBottomSheetState();
}

class _StoreFilterBottomSheetState extends State<StoreFilterBottomSheet> {
  SortOption? _sort;
  ConditionType? _condition;
  DeliveryType? _delivery;

  @override
  void initState() {
    super.initState();
    _sort = widget.sort;
    _condition = widget.selectedConditionType;
    _delivery = widget.selectedDeliveryType;
  }

  void _handleReset() {
    setState(() {
      _sort = null;
      _condition = null;
      _delivery = null;
    });
    widget.minPriceController.clear();
    widget.maxPriceController.clear();
    widget.onReset();
  }

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
              StoreFilterSheetHeaderSection(onReset: _handleReset),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    children: <Widget>[
                      StoreFilterSheetCustomerReviewTile(
                        sort: _sort,
                        onChanged: (SortOption? value) {
                          
                          setState(() {
                            _sort = value;
                          });
                          widget.onSortChanged(value);
                        },
                      ),
                      ExpandablePriceRangeTile(
                        minPriceController: widget.minPriceController,
                        maxPriceController: widget.maxPriceController,
                      ),

                      if (widget.showStoreFields)
                        StoreFilterSheetConditionTile(
                          selectedConditionType: _condition,
                          onChanged: (ConditionType? value) {
                            setState(() {
                              _condition = value;
                            });
                            widget.onConditionChanged?.call(value);
                          },
                        ),
                      if (widget.showStoreFields)
                        StoreFilterSheetDeliveryTypeTile(
                          selectedDeliveryType: _delivery,
                          onChanged: (DeliveryType? value) {
                            setState(() {
                              _delivery = value;
                            });
                            widget.onDeliveryTypeChanged?.call(value);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              StoreFilterSheetApplyButton(
                isLoading: widget.isLoading,
                onApply: widget.onApply,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StoreFilterSheetCustomerReviewTile extends StatelessWidget {
  const StoreFilterSheetCustomerReviewTile({
    required this.sort,
    required this.onChanged,
    super.key,
  });

  final SortOption? sort;
  final ValueChanged<SortOption?> onChanged;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'sort_by'.tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: DropdownButtonFormField<SortOption>(
        initialValue: sort,
        isExpanded: true,
        hint: Text(
          'sort_by_choice'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class ExpandablePriceRangeTile extends StatefulWidget {
  const ExpandablePriceRangeTile({
    required this.minPriceController,
    required this.maxPriceController,
    super.key,
  });

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  @override
  State<ExpandablePriceRangeTile> createState() =>
      _ExpandablePriceRangeTileState();
}

class _ExpandablePriceRangeTileState extends State<ExpandablePriceRangeTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
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
                    controller: widget.minPriceController,
                    keyboardType: TextInputType.number,
                    labelText: 'min_price'.tr(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    controller: widget.maxPriceController,
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
  }
}

class StoreFilterSheetConditionTile extends StatelessWidget {
  const StoreFilterSheetConditionTile({
    required this.selectedConditionType,
    required this.onChanged,
    super.key,
  });

  final ConditionType? selectedConditionType;
  final ValueChanged<ConditionType?>? onChanged;

  @override
  Widget build(BuildContext context) {
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
        initialValue: selectedConditionType,
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        items: ConditionType.values.map((ConditionType type) {
          return DropdownMenuItem<ConditionType>(
            value: type,
            child: Text(
              type.code.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class StoreFilterSheetDeliveryTypeTile extends StatelessWidget {
  const StoreFilterSheetDeliveryTypeTile({
    required this.selectedDeliveryType,
    required this.onChanged,
    super.key,
  });

  final DeliveryType? selectedDeliveryType;
  final ValueChanged<DeliveryType?>? onChanged;

  @override
  Widget build(BuildContext context) {
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
        initialValue: selectedDeliveryType,
        isExpanded: true,
        hint: Text(
          'select_delivery_type'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class StoreFilterSheetHeaderSection extends StatelessWidget {
  const StoreFilterSheetHeaderSection({required this.onReset, super.key});

  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CloseButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Text(
          'filter'.tr(),
          style: TextTheme.of(
            context,
          ).bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: () {
            onReset();
          },
          child: Text(
            'reset'.tr(),
            style: TextTheme.of(
              context,
            ).labelSmall?.copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}

class StoreFilterSheetApplyButton extends StatelessWidget {
  // <-- control variable

  const StoreFilterSheetApplyButton({
    required this.onApply,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onApply;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomElevatedButton(
        onTap: () {
          onApply();
          Navigator.pop(context);
        },
        title: 'apply'.tr(),
        isLoading: isLoading,
      ),
    );
  }
}
