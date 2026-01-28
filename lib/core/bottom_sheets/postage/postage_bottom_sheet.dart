import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../sources/data_state.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../features/personal/basket/domain/enums/cart_type.dart';
import '../../../features/postage/domain/entities/postage_detail_response_entity.dart';
import '../../widgets/buttons/custom_elevated_button.dart';
import '../../widgets/utils/app_snackbar.dart';
import 'widgets/postage_header.dart';
import 'widgets/postage_item_card.dart';
import '../../../features/postage/presentation/controllers/postage_controller.dart';

class PostageBottomSheet extends StatefulWidget {
  const PostageBottomSheet({super.key});

  @override
  State<PostageBottomSheet> createState() => _PostageBottomSheetState();
}

class _PostageBottomSheetState extends State<PostageBottomSheet> {
  bool _isSubmitting = false;
  final PostageController _controller = PostageController();

  Future<void> _submitPostage(CartProvider cartPro) async {
    setState(() => _isSubmitting = true);

    final DataState<void> outcome = await _controller
        .submitPostageAndFetchBilling(cartPro);

    if (!mounted) return;

    if (outcome is DataSuccess<void>) {
      cartPro.setCartType(CartType.reviewOrder);
      Navigator.of(context).pop(cartPro.selectedShippingItems);
    } else {
      AppSnackBar.show(
        outcome.exception?.reason ?? 'failed_to_submit_shipping'.tr(),
      );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();
    final PostageDetailResponseEntity? postage = cartPro.postageResponseEntity;
    final List<PostageItemDetailEntity>? entries = postage?.detail;

    if (postage == null || entries == null || entries.isEmpty) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No shipping options available.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(child: PostageHeader()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      Navigator.of(context).pop(cartPro.selectedShippingItems),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                cacheExtent: 5000,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final String cartItemId = entries[index].cartItemId;
                  final PostageItemDetailEntity detail = entries[index];
                  return PostageItemCard(
                    cartItemId: cartItemId,
                    detail: detail,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButton(
                onTap: () => _isSubmitting ? null : _submitPostage(cartPro),
                title: 'Submit'.tr(),
                isLoading: _isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
