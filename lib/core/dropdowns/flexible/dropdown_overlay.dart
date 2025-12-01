import 'package:flutter/material.dart';

class DropdownOverlay<T> extends StatelessWidget {
  const DropdownOverlay({
    required this.items,
    required this.selectedItem,
    required this.maxHeight,
    required this.tileBuilder,
    required this.onItemSelected,
    this.loading = false,
    this.noResultsText,
    super.key,
  });
  final List<T> items;
  final T? selectedItem;
  final double maxHeight;
  final Widget Function(BuildContext, T, bool) tileBuilder;
  final void Function(T) onItemSelected;
  final bool loading;
  final String? noResultsText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            : items.isEmpty
            ? Center(child: Text(noResultsText ?? 'No results found'))
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  final isSelected = item == selectedItem;
                  return InkWell(
                    onTap: () => onItemSelected(item),
                    child: tileBuilder(context, item, isSelected),
                  );
                },
              ),
      ),
    );
  }
}
