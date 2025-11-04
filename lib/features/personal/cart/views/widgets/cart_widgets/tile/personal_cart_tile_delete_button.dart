import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../../../data/sources/local_cart.dart';
import '../../../providers/cart_provider.dart';

class PersonalCartTileDeleteButton extends StatefulWidget {
  const PersonalCartTileDeleteButton({
    required this.item,
    super.key,
  });

  final CartItemEntity item;

  @override
  State<PersonalCartTileDeleteButton> createState() =>
      _PersonalCartTileDeleteButtonState();
}

class _PersonalCartTileDeleteButtonState
    extends State<PersonalCartTileDeleteButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Loader();

    return GestureDetector(
      onTap: () async {
        if (mounted) setState(() => _isLoading = true);
        try {
          await Provider.of<CartProvider>(context, listen: false)
              .removeItem(widget.item.cartItemID);
        } catch (e) {
          // ignore: use_build_context_synchronously
          AppSnackBar.showSnackBar(context, e.toString());
        }
        if (mounted) setState(() => _isLoading = false);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: ColorScheme.of(context).outline.withValues(alpha: 0.1),
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: Text(
          'delete'.tr(),
          style:
              TextStyle(color: ColorScheme.of(context).primary, fontSize: 12),
        ),
      ),
    );
  }
}
