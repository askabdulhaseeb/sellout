import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../visits/view/book_visit/widgets/visiting_update_buttons_widget.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class VisitingMessageTile extends StatelessWidget {
  const VisitingMessageTile({
    required this.message,
    required this.showButtons,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;

  /// Returns a title and subtitle message based on the status
  Map<String, String> _statusTexts(
      StatusType status, String date, String time) {
    switch (status) {
      case StatusType.active:
        return <String, String>{
          'title': tr('your_booking_details'),
          'subtitle':
              '${tr('you_are_booked_in_for_a_visiting_on')} $date $time\n${tr('we_looke_forward_to_seeing_you')}'
        };
      case StatusType.pending:
        return <String, String>{
          'title': tr('your_booking_pending'),
          'subtitle': tr('we_will_notify_once_confirmed'),
        };
      case StatusType.cancelled:
        return <String, String>{
          'title': tr('your_booking_cancelled'),
          'subtitle': tr('please_contact_support'),
        };
      default:
        return <String, String>{
          'title': tr('your_booking_rejected'),
          'subtitle': tr('you_can_try_booking_again'),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(message.visitingDetail?.postID ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        final String imageUrl =
            post?.fileUrls.isNotEmpty == true ? post!.fileUrls.first.url : '';
        final String title = post?.title ?? '';
        final String currency = post?.currency ?? '**';
        final double price = post?.price ?? 0.0;
        final String date =
            message.visitingDetail?.dateTime.dateWithMonthOnly ?? '';
        final String time = message.visitingDetail?.visitingTime ?? '';
        final String meet = post?.meetUpLocation?.address ?? '';
        final StatusType status =
            message.visitingDetail?.status ?? StatusType.inActive;

        final Map<String, String> texts = _statusTexts(status, date, time);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: showButtons
                  ? Colors.transparent
                  : ColorScheme.of(context).outlineVariant,
            ),
          ),
          margin: EdgeInsets.all(showButtons ? 0 : 12),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (showButtons)
                VisitingMessageTileUpdateButtonsWidget(
                    message: message, post: post),
              // Status text block — centered
              Text(
                texts['title'] ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                texts['subtitle'] ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black87),
              ),
              // Image + Details — nicely spaced
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomNetworkImage(
                      size: 80,
                      imageURL: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${'date'.tr()}: $date',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('${'time'.tr()}: $time',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('${'meet'.tr()}: $meet',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title + Price — centered horizontally
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${CountryHelper.currencySymbolHelper(currency)} $price',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
