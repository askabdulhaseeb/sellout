import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/extension/int_ext.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../data/sources/local_cart.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: qty == 1
              ? null
              : () async {
                  setState(() {
                    qty--;
                  });
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(seconds: 2), () async {
                    await Provider.of<CartProvider>(context, listen: false)
                        .updateQty(widget.item, qty);
                  });
                },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          qty.putInStart(sign: '0', length: 2),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: qty == widget.post?.quantity
              ? null
              : () async {
                  setState(() {
                    qty++;
                  });
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(seconds: 2), () async {
                    await Provider.of<CartProvider>(context, listen: false)
                        .updateQty(widget.item, qty);
                  });
                },
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
