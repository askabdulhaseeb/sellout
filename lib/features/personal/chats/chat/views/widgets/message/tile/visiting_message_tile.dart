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

  /// Title changes according to status
  String _statusTitle(StatusType status) {
    switch (status) {
      case StatusType.accepted:
        return tr('you_are_booked_in_for_a_visiting');
      case StatusType.pending:
        return tr('booking_pending');
      case StatusType.cancelled:
        return tr('booking_cancelled');
      default:
        return tr('booking_rejected');
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
        final double price = post?.price ?? 0;
        final String date =
            message.visitingDetail?.dateTime.dateWithMonthOnly ?? '';
        final String time = message.visitingDetail?.visitingTime ?? '';
        final String meet = post?.meetUpLocation?.address ?? '';
        final StatusType status =
            message.visitingDetail?.status ?? StatusType.pending;
        // dynamic title & one subtitle
        final String statusTitle = _statusTitle(status);
        final String subtitle = tr('your_booking_details');
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: showButtons
                  ? Colors.transparent
                  : ColorScheme.of(context).outlineVariant,
            ),
          ),
          margin: EdgeInsets.all(showButtons ? 0 : 4),
          padding: showButtons
              ? const EdgeInsets.symmetric(horizontal: 16)
              : const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (showButtons)
                VisitingMessageTileUpdateButtonsWidget(
                    message: message, post: post),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                statusTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 8),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              const SizedBox(height: 6),
              // Title + Price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${CountryHelper.currencySymbolHelper(currency)} $price',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
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
