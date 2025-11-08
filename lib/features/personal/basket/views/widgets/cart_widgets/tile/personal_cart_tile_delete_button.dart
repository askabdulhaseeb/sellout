import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../../../data/sources/local/local_cart.dart';
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

  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);

    try {
      final DataState<bool> result =
          await Provider.of<CartProvider>(context, listen: false)
              .removeItem(widget.item.cartItemID);

      if (!mounted) return;

      if (result is DataSuccess<bool>) {
        AppSnackBar.showSnackBar(
          context,
          'item_removed_successfully'.tr(),
          color: Theme.of(context).colorScheme.primary,
        );
      } else if (result is DataFailer<bool>) {
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'failed_to_remove_item'.tr(),
          color: Theme.of(context).colorScheme.errorContainer,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showSnackBar(
          context,
          e.toString(),
          color: Theme.of(context).colorScheme.errorContainer,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 60,
        height: 32,
        child: Center(child: Loader()),
      );
    }

    return GestureDetector(
      onTap: _handleDelete,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          'delete'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
