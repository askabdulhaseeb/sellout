import 'package:flutter/material.dart';

class ExpandableTileItem {
  const ExpandableTileItem({
    required this.id,
    required this.title,
    required this.icon,
    this.subtitle,
    this.body,
    this.initiallyExpanded = false,
    this.isSelected = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final WidgetBuilder? body;
  final bool initiallyExpanded;
  final bool isSelected;
}

class CustomExpandableTileGroup extends StatefulWidget {
  const CustomExpandableTileGroup({required this.items, super.key});

  final List<ExpandableTileItem> items;

  @override
  State<CustomExpandableTileGroup> createState() =>
      _CustomExpandableTileGroupState();
}

class _CustomExpandableTileGroupState extends State<CustomExpandableTileGroup> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    final int firstExpanded = widget.items.indexWhere(
      (ExpandableTileItem e) => e.initiallyExpanded,
    );
    if (firstExpanded != -1) {
      _expandedIndex = firstExpanded;
    }
  }

  @override
  void didUpdateWidget(CustomExpandableTileGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger rebuild when items change
    if (oldWidget.items != widget.items) {
      // Items list has changed, state will be rebuilt
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        for (int idx = 0; idx < widget.items.length; idx++) ...<Widget>[
          _ExpandableTile(
            key: ValueKey<String>(widget.items[idx].id),
            item: widget.items[idx],
            isExpanded: _expandedIndex == idx,
            onToggle: () {
              setState(() {
                _expandedIndex = _expandedIndex == idx ? null : idx;
              });
            },
            scheme: colorScheme,
          ),
          if (idx < widget.items.length - 1)
            Divider(color: colorScheme.outlineVariant, height: 1),
        ],
      ],
    );
  }
}

class _ExpandableTile extends StatelessWidget {
  const _ExpandableTile({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.scheme,
    super.key,
  });

  final ExpandableTileItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final bool hasBody = item.body != null;

    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Container(
            width: item.isSelected ? 4 : 0,
            color: item.isSelected ? scheme.primary : Colors.transparent,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (hasBody)
                  InkWell(
                    onTap: onToggle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            item.icon,
                            color: isExpanded
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isExpanded
                                            ? scheme.primary
                                            : scheme.onSurface,
                                      ),
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: isExpanded
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(item.icon, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurface,
                                    ),
                              ),
                              if (item.subtitle != null)
                                Text(
                                  item.subtitle!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isExpanded && hasBody)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: item.body!(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
