import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
            '${CountryHelper.currencySymbolHelper(widget.post?.currency)}${(widget.item.quantity * (widget.post?.price ?? 0)).toStringAsFixed(0)}'
                .toUpperCase(),
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        _isLoading
            ? const Loader()
            : GestureDetector(
                onTap: () async {
                  if (mounted) {
                    setState(() => _isLoading = true);
                  }
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
                  padding: const EdgeInsets.all(6),
                  child: const CustomSvgIcon(
                    assetPath: AppStrings.selloutCartTrashIcon,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
      ],
    );
  }
}
