import 'package:flutter/material.dart';

class CustomMarketplaceGridView<T> extends StatelessWidget {
  const CustomMarketplaceGridView({
    super.key,
    this.items,
    this.count,
    this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.childAspectRatio = 0.75,
    this.padding = const EdgeInsets.all(12),
    this.scrollable = false,
  }) : assert(
          itemBuilder != null || T == Widget,
          'itemBuilder must be provided unless T is Widget',
        );

  final List<T>? items;
  final int? count;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final EdgeInsets padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final int itemCount = count ?? items?.length ?? 0;

    return GridView.builder(
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: !scrollable,
      padding: padding,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (items != null && items!.isNotEmpty) {
          final item = items![index];
          if (itemBuilder != null) {
            return itemBuilder!(context, item);
          } else if (item is Widget) {
            return item;
          } else {
            throw Exception('Provide a valid itemBuilder or List<Widget>.');
          }
        } else {
          // items are not provided, use count + itemBuilder only
          if (itemBuilder != null) {
            return itemBuilder!(context, items?[index] as T);
          } else {
            throw Exception('Either provide items or an itemBuilder.');
          }
        }
      },
    );
  }
}
