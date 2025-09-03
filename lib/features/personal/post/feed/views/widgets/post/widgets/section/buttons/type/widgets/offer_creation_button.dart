import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../../../../../../../chats/chat/views/screens/chat_screen.dart';
import '../../../../../../../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../../../../../../../chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../domain/entities/size_color/color_entity.dart';
import '../../../../../../../../../domain/params/create_offer_params.dart';
import '../../../../../../../../../domain/usecase/create_offer_usecase.dart';
import '../../../bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';

class OfferCreationButton extends StatelessWidget {
  const OfferCreationButton({
    required this.post,
    required this.widget,
    required this.selectedSize,
    required this.selectedColor,
    required this.priceController,
    required this.quantity,
    required this.formKey,
    super.key,
  });

  final MakeOfferBottomSheet widget;
  final PostEntity post;
  final String? selectedSize;
  final ColorEntity? selectedColor;
  final TextEditingController priceController;
  final int quantity;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final enteredAmount = int.tryParse(priceController.text.trim()) ?? 0;
    return CustomElevatedButton(
      isLoading: false,
      title: 'make_offer'.tr(),
      onTap: () async {
        if (priceController.text.trim().isEmpty) {
          AppSnackBar.showSnackBar(context, 'price_is_required'.tr());
          return;
        }
        if (enteredAmount < widget.post.minOfferAmount) {
          AppSnackBar.showSnackBar(context, 'offer_amount_too_low'.tr());
          return;
        }

        // direct createOffer here
        try {
          final CreateOfferUsecase createOfferUsecase =
              CreateOfferUsecase(locator());
          final DataState<bool> result =
              await createOfferUsecase.call(CreateOfferparams(
            postId: widget.post.postID,
            offerAmount: double.parse(priceController.text.trim()),
            currency: widget.post.currency!,
            quantity: quantity,
            listId: widget.post.listID,
            size: selectedSize,
            color: selectedColor?.code,
          ));

          if (result is DataSuccess && result.data != null) {
            final DataState<List<ChatEntity>> chatResult =
                await GetMyChatsUsecase(locator()).call(<String>[result.data!]);

            if (chatResult is DataSuccess && chatResult.entity!.isNotEmpty) {
              Provider.of<ChatProvider>(context, listen: false)
                  .setChat(context, chatResult.entity!.first);

              Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
            } else {
              AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
            }
          } else {
            AppSnackBar.showSnackBar(
              context,
              result.exception?.reason ?? 'something_wrong'.tr(),
            );
          }
        } catch (e) {
          AppSnackBar.showSnackBar(context, e.toString());
        } finally {
          (false);
        }
      },
    );
  }
}
