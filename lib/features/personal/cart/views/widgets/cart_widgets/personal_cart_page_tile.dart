import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/enums/basket_type.dart';
import '../../providers/cart_provider.dart';

class PersonalCartPageTile extends StatelessWidget {
  const PersonalCartPageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, _) {
      cartPro.basketType;
      final List<BasketType> steps = BasketType.list();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(steps.length * 2 - 1, (int index) {
          // Add connector line between buttons
          if (index.isOdd) {
            return Container(
              height: 3,
              width: 40,
              color: Theme.of(context).dividerColor,
            );
          }

          final int stepIndex = index ~/ 2;
          final BasketType step = steps[stepIndex];
          return _IconButton(
            title: step.code.tr(),
            isActive: cartPro.page == stepIndex + 1,
            onTap: () {
              // cartPro.page = stepIndex + 1;
            },
          );
        }),
      );
    });
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                Icons.check,
                color: color,
                size: 14,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
