import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loader.dart';
import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../data/sources/local_cart.dart';
import '../../../providers/cart_provider.dart';

class PersonalCartTileTrailingSection extends StatefulWidget {
  const PersonalCartTileTrailingSection({
    required this.item,
    required this.post,
    super.key,
  });
  final CartItemEntity item;
  final PostEntity? post;

  @override
  State<PersonalCartTileTrailingSection> createState() =>
      _PersonalCartTileTrailingSectionState();
}

class _PersonalCartTileTrailingSectionState
    extends State<PersonalCartTileTrailingSection> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${widget.item.quantity * (widget.post?.price ?? 0)} ${widget.post?.currency}'
              .toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        _isLoading
            ? const Loader()
            : ShadowContainer(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await Provider.of<CartProvider>(context, listen: false)
                        .removeItem(widget.item.cartItemID);
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    AppSnackBar.showSnackBar(context, e.toString());
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
        if (!_isLoading)
          InkWell(
            onTap: () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                final DataState<bool> result =
                    await Provider.of<CartProvider>(context, listen: false)
                        .updateStatus(widget.item);
                if (result is DataFailer) {
                  AppSnackBar.showSnackBar(
                      // ignore: use_build_context_synchronously
                      context,
                      result.exception?.message ?? 'something-wrong');
                }
              } catch (e) {
                // ignore: use_build_context_synchronously
                AppSnackBar.showSnackBar(context, e.toString());
              }
              setState(() {
                _isLoading = false;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.item.type.tileActionCode.tr(),
                style: TextStyle(color: primaryColor, fontSize: 14),
              ).tr(),
            ),
          ),
      ],
    );
  }
}
