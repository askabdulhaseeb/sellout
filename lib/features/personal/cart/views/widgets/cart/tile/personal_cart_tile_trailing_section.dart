import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loader.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
            '${widget.item.quantity * (widget.post?.price ?? 0)} ${widget.post?.currency}'
                .toUpperCase(),
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        _isLoading
            ? const Loader()
            : GestureDetector(
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: ColorScheme.of(context)
                            .outline
                            .withValues(alpha: 0.1)),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
      ],
    );
  }
}
