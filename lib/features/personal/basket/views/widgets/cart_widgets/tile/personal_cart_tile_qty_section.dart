import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/extension/int_ext.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';

import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../data/sources/local/local_cart.dart';
import '../../../providers/cart_provider.dart';

class PersonalCartTileQtySection extends StatefulWidget {
  const PersonalCartTileQtySection({
    required this.item,
    required this.post,
    super.key,
  });
  final CartItemEntity item;
  final PostEntity? post;

  @override
  State<PersonalCartTileQtySection> createState() =>
      _PersonalCartTileQtySectionState();
}

class _PersonalCartTileQtySectionState
    extends State<PersonalCartTileQtySection> {
  Timer? _debounce;
  int qty = 0;
  bool _isUpdating = false;

  @override
  void initState() {
    qty = widget.item.quantity;
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _updateQuantity(int newQty) async {
    if (_isUpdating || newQty == widget.item.quantity) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final DataState<bool> result =
          await Provider.of<CartProvider>(context, listen: false)
              .updateQty(widget.item, newQty);

      if (result is DataFailer && mounted) {
        // Revert quantity on failure
        setState(() {
          qty = widget.item.quantity;
        });
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'Failed to update quantity',
          color: Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          qty = widget.item.quantity;
        });
        AppSnackBar.showSnackBar(
          context,
          'Error updating quantity: ${e.toString()}',
          color: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  void _handleQuantityChange(int newQty) {
    setState(() {
      qty = newQty;
    });

    // Cancel existing timer
    _debounce?.cancel();

    // Start new timer for debounced update
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _updateQuantity(newQty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int maxQty = widget.post?.quantity ?? 99;

    return Row(
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onPressed: (qty <= 1 || _isUpdating)
              ? null
              : () => _handleQuantityChange(qty - 1),
          icon: Icon(
            Icons.remove_circle_outline,
            color: (qty <= 1 || _isUpdating)
                ? Theme.of(context).disabledColor
                : null,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            qty.putInStart(sign: '0', length: 2),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _isUpdating ? Theme.of(context).disabledColor : null,
                ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onPressed: (qty >= maxQty || _isUpdating)
              ? null
              : () => _handleQuantityChange(qty + 1),
          icon: Icon(
            Icons.add_circle_outline,
            color: (qty >= maxQty || _isUpdating)
                ? Theme.of(context).disabledColor
                : null,
          ),
        ),
        if (_isUpdating)
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
