import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../domain/enums/cart_type.dart';
import '../providers/cart_provider.dart';

class CartTabSelectionWidget extends StatelessWidget {
  const CartTabSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CartType> allTabs = CartType.list();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          const double moreButtonWidth = 80;
          const double minTabWidth = 80;
          int maxVisibleTabs = allTabs.length;
          double totalTabWidth = allTabs.length * minTabWidth;
          if (totalTabWidth > availableWidth) {
            maxVisibleTabs = ((availableWidth - moreButtonWidth) ~/ minTabWidth)
                .clamp(0, allTabs.length);
          }

          final List<CartType> visibleTabs =
              allTabs.take(maxVisibleTabs).toList();
          final List<CartType> hiddenTabs =
              allTabs.skip(visibleTabs.length).toList();

          return Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider cartPro, _) {
              final int totalTabs =
                  visibleTabs.length + (hiddenTabs.isNotEmpty ? 1 : 0);
              final double tabWidth = availableWidth / totalTabs;
              return SizedBox(
                height: 36,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ...visibleTabs.map(
                          (CartType type) => SizedBox(
                            width: tabWidth,
                            child: _IconButton(
                              title: type.code.tr(),
                              isSelected: cartPro.cartType == type,
                              onPressed: () => cartPro.cartType = type,
                            ),
                          ),
                        ),
                        if (hiddenTabs.isNotEmpty)
                          SizedBox(
                            width: tabWidth,
                            child: PopupMenuButton<CartType>(
                              tooltip: 'More',
                              offset: const Offset(0, 36),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onSelected: (CartType type) {
                                cartPro.cartType = type;
                              },
                              itemBuilder: (BuildContext context) {
                                return hiddenTabs
                                    .map(
                                      (CartType type) =>
                                          PopupMenuItem<CartType>(
                                        value: type,
                                        child: Text(type.code.tr()),
                                      ),
                                    )
                                    .toList();
                              },
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: null,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'more'.tr(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: hiddenTabs.contains(
                                                      cartPro.cartType)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                              fontWeight: hiddenTabs.contains(
                                                      cartPro.cartType)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 18,
                                            color: hiddenTabs
                                                    .contains(cartPro.cartType)
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color:
                                          hiddenTabs.contains(cartPro.cartType)
                                              ? AppTheme.primaryColor
                                              : Colors.transparent,
                                    ),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: ColorScheme.of(context)
                                              .outlineVariant),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isSelected,
    this.onPressed,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.outline,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            ),
          ),
          Container(
            height: 1,
            decoration:
                BoxDecoration(color: ColorScheme.of(context).outlineVariant),
          )
        ],
      ),
    );
  }
}
