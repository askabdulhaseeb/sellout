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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: widget.items[idx].isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
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
                      Divider(
                        color: colorScheme.outlineVariant,
                        height: 1,
                        thickness: 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
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

    Widget buildTileRow() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 12),
          Icon(
            item.icon,
            color: isExpanded ? scheme.primary : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isExpanded ? scheme.primary : scheme.onSurface,
                  ),
                ),
                if (item.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasBody)
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isExpanded ? scheme.primary : scheme.onSurfaceVariant,
            ),
          const SizedBox(width: 16),
        ],
      );
    }

    Widget tileContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: buildTileRow(),
    );

    if (isExpanded && hasBody) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasBody ? onToggle : null,
              borderRadius: BorderRadius.zero,
              child: tileContent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 0, 16, 12),
            child: item.body!(context),
          ),
        ],
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasBody ? onToggle : null,
          borderRadius: BorderRadius.zero,
          child: tileContent,
        ),
      );
    }
  }
}