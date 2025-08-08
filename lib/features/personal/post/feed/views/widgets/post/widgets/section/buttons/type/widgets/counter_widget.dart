import 'package:flutter/material.dart';

class PostCounterWidget extends StatefulWidget {
  const PostCounterWidget({
    required this.initialQuantity,
    required this.maxQuantity,
    required this.onChanged,
    super.key,
  });

  final int initialQuantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  State<PostCounterWidget> createState() => _PostCounterWidgetState();
}

class _PostCounterWidgetState extends State<PostCounterWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity < 1 || newQuantity > widget.maxQuantity) return;
    setState(() {
      quantity = newQuantity;
    });
    widget.onChanged(quantity);
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(6);
    final BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      borderRadius: borderRadius,
    );

    return Container(
      height: 47,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            borderRadius: borderRadius,
            onTap: () => _updateQuantity(quantity - 1),
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(4),
              decoration: decoration,
              child: Icon(Icons.remove,
                  size: 12, color: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(quantity.toString(),
                style: TextTheme.of(context).titleMedium),
          ),
          InkWell(
            borderRadius: borderRadius,
            onTap: () => _updateQuantity(quantity + 1),
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(4),
              decoration: decoration,
              child: Icon(Icons.add,
                  size: 12, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
