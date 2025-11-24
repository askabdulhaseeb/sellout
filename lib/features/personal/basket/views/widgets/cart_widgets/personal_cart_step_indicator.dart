import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';

enum _StepState { completed, current, upcoming }

class PersonalCartStepIndicator extends StatelessWidget {
  const PersonalCartStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, _) {
      final int currentIndex = cartPro.cartType.index;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Row for icons and progress lines
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: _IconContainer(
                    state: _getState(0, currentIndex),
                    onTap: currentIndex > 0
                        ? () => cartPro.setCartType(CartType.values[0])
                        : null,
                  ),
                ),
                _ProgressLine(isActive: currentIndex > 0),
                Expanded(
                  child: _IconContainer(
                    state: _getState(1, currentIndex),
                    onTap: currentIndex > 1
                        ? () => cartPro.setCartType(CartType.values[1])
                        : null,
                  ),
                ),
                _ProgressLine(isActive: currentIndex > 1),
                Expanded(
                  child: _IconContainer(
                    state: _getState(2, currentIndex),
                    onTap: currentIndex > 2
                        ? () => cartPro.setCartType(CartType.values[2])
                        : null,
                  ),
                ),
                _ProgressLine(isActive: currentIndex > 2),
                Expanded(
                  child: _IconContainer(
                    state: _getState(3, currentIndex),
                    onTap: currentIndex > 3
                        ? () => cartPro.setCartType(CartType.values[3])
                        : null,
                  ),
                ),
              ],
            ),
            // Row for texts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: _TextLabel(
                    title: 'shopping_basket'.tr(),
                    state: _getState(0, currentIndex),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _TextLabel(
                    title: 'checkout_order'.tr(),
                    state: _getState(1, currentIndex),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _TextLabel(
                    title: 'review_order'.tr(),
                    state: _getState(2, currentIndex),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _TextLabel(
                    title: 'payment'.tr(),
                    state: _getState(3, currentIndex),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  _StepState _getState(int stepIndex, int currentIndex) {
    if (stepIndex < currentIndex) return _StepState.completed;
    if (stepIndex == currentIndex) return _StepState.current;
    return _StepState.upcoming;
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.state,
    this.onTap,
  });
  final _StepState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = state == _StepState.upcoming
        ? Theme.of(context).disabledColor
        : Theme.of(context).primaryColor;

    final IconData icon = switch (state) {
      _StepState.completed => Icons.check,
      _StepState.current => Icons.check,
      _StepState.upcoming => Icons.check,
    };

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey<IconData>(icon),
          width: AppSpacing.md,
          height: AppSpacing.md,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
            color: state == _StepState.upcoming
                ? Colors.transparent
                : color.withValues(alpha: 0.1),
          ),
          child: FittedBox(
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: content,
      );
    } else {
      return content;
    }
  }
}

class _TextLabel extends StatelessWidget {
  const _TextLabel({
    required this.title,
    required this.state,
  });
  final String title;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final Color color = state == _StepState.upcoming
        ? Theme.of(context).disabledColor
        : Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(color: color, fontSize: 8),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 3,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
