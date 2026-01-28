import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../data/sources/local/local_cart.dart';
import '../../../providers/cart_provider.dart';

class PersonalCartTileDeleteButton extends StatefulWidget {
  const PersonalCartTileDeleteButton({required this.item, super.key});

  final CartItemEntity item;

  @override
  State<PersonalCartTileDeleteButton> createState() =>
      _PersonalCartTileDeleteButtonState();
}

class _PersonalCartTileDeleteButtonState
    extends State<PersonalCartTileDeleteButton> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    if (_isLoading) return; // prevent double taps
    setState(() => _isLoading = true);
    try {
      final CartProvider provider = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      final DataState<bool> result = await provider.removeItem(
        widget.item.cartItemID,
      );

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
          color: Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showSnackBar(
          context,
          e.toString(),
          color: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: _isLoading ? null : _handleDelete,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_isLoading) ...<Widget>[
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(scheme.error),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            'delete'.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: _isLoading ? scheme.outline : scheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
