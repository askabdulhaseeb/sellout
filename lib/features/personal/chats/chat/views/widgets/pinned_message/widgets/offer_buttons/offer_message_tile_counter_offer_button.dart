import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../../../../post/feed/views/widgets/post/widgets/section/bottomsheets/make_offer_bottomsheet/make_an_offer_bottomsheet.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class OfferMessageTileCounterOfferButton extends StatelessWidget {
  const OfferMessageTileCounterOfferButton({required this.message, super.key});
  final MessageEntity message;
  @override
  Widget build(BuildContext context) {
    void showOfferBottomSheet(BuildContext context, MessageEntity message) {
      final GetSpecificPostUsecase getPostByIdUsecase = GetSpecificPostUsecase(
        locator(),
      );

      showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FutureBuilder<DataState<PostEntity>>(
            future: getPostByIdUsecase.call(
              GetSpecificPostParam(postId: message.offerDetail?.postId ?? ''),
            ),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<DataState<PostEntity>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.entity == null) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(child: Text('no_post_found'.tr())),
                    );
                  } else {
                    final PostEntity post = snapshot.data!.entity!;
                    return MakeOfferBottomSheet(post: post, message: message);
                  }
                },
          );
        },
      );
    }

    return Expanded(
      child: CustomElevatedButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        borderRadius: BorderRadius.circular(6),
        textStyle: TextTheme.of(context).bodySmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        border: Border.all(color: Colors.transparent),
        bgColor: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        title: 'counter'.tr(),
        isLoading: false,
        onTap: () {
          showOfferBottomSheet(context, message);
        },
      ),
    );
  }
}
