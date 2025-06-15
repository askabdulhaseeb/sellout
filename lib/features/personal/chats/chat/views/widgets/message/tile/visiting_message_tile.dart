import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../book_visit/view/widgets/visiting_update_buttons_widget.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../data/sources/local/local_message.dart';
import '../../../../domain/entities/getted_message_entity.dart';

class VisitingMessageTile extends HookWidget {
  const VisitingMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<MessageEntity> liveMessage =
        useState<MessageEntity>(message);
    final String chatId = message.chatId;

    useEffect(() {
      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(LocalChatMessage.boxTitle);

      final GettedMessageEntity? initialEntity = box.get(chatId);
      if (initialEntity != null) {
        final MessageEntity updated = initialEntity.messages.firstWhere(
            (MessageEntity m) => m.messageId == message.messageId,
            orElse: () => message);
        liveMessage.value = updated;
      }

      final StreamSubscription sub =
          box.watch(key: chatId).listen((BoxEvent event) {
        final GettedMessageEntity? updatedEntity = box.get(chatId);
        if (updatedEntity != null) {
          final MessageEntity updatedMsg = updatedEntity.messages.firstWhere(
              (MessageEntity m) => m.messageId == message.messageId,
              orElse: () => message);
          liveMessage.value = updatedMsg;
        }
      });

      return sub.cancel;
    }, <Object?>[chatId, message.messageId]);

    const TextStyle boldStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(
        liveMessage.value.visitingDetail?.postID ??
            liveMessage.value.offerDetail?.post.postID ??
            '',
      ),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ShadowContainer(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                VisitingUpdateButtonsWidget(
                    message: liveMessage.value, post: post),
                Opacity(
                  opacity: 0.6,
                  child: const Text(
                    'your_booking_details',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ).tr(),
                ),
                Text(
                  '${'you_are_booked_in_for_a_visiting_on'.tr()}:',
                  style: boldStyle,
                ),
                Text(
                  liveMessage
                          .value.visitingDetail?.dateTime.dateWithMonthOnly ??
                      'Date not set',
                  style: boldStyle,
                ),
                Text(
                  liveMessage.value.visitingDetail?.visitingTime ??
                      'Time not set',
                  style: boldStyle,
                ),
                const Text(
                  'we_looke_forward_to_seeing_you',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ).tr(),
                const SizedBox(height: 12),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(
                        imageURL:
                            liveMessage.value.offerDetail?.post.imageURL ??
                                post?.fileUrls.first.url ??
                                '',
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        liveMessage.value.offerDetail?.post.title ??
                            post?.title ??
                            'na',
                        style: boldStyle,
                      ),
                    ),
                    Text(
                      '${liveMessage.value.offerDetail?.post.currency ?? post?.currency} '
                      '${liveMessage.value.offerDetail?.post.price ?? post?.price}',
                      style: boldStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
