import 'package:flutter/material.dart';
import '../../../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';

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

    return CustomElevatedButton(
      prefixSuffixPadding: const EdgeInsets.symmetric(horizontal: 4),
      rowAlignment: MainAxisAlignment.spaceBetween,
      bgColor: Theme.of(context).scaffoldBackgroundColor,
      border: Border.all(color: AppTheme.primaryColor, width: 2),
      isLoading: false,
      onTap: () {},
      prefix: InkWell(
        borderRadius: borderRadius,
        onTap: () => _updateQuantity(quantity - 1),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: decoration,
          child: Icon(Icons.remove,
              size: 12, color: Theme.of(context).primaryColor),
        ),
      ),
      suffix: InkWell(
        borderRadius: borderRadius,
        onTap: () => _updateQuantity(quantity + 1),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: decoration,
          child:
              Icon(Icons.add, size: 12, color: Theme.of(context).primaryColor),
        ),
      ),
      title: quantity.toString(),
      textStyle: const TextStyle(fontSize: 16),
    );
  }
}
