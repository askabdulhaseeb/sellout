import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../visits/view/book_visit/widgets/visiting_update_buttons_widget.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../providers/chat_provider.dart';

class VisitingMessageTile extends StatefulWidget {
  const VisitingMessageTile({
    required this.message,
    required this.showButtons,
    this.collapsable = false,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;
  final bool collapsable;

  @override
  State<VisitingMessageTile> createState() => _VisitingMessageTileState();
}

class _VisitingMessageTileState extends State<VisitingMessageTile> {
  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context);
    final bool expanded = !widget.collapsable ||
        (widget.collapsable && pro.expandVisitingMessage);

    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(widget.message.visitingDetail?.postID ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        final String imageUrl =
            post?.fileUrls.isNotEmpty == true ? post!.fileUrls.first.url : '';
        final String title = post?.title ?? '';
        final String currency = post?.currency ?? '**';
        final double price = post?.price ?? 0.0;
        final String date =
            widget.message.visitingDetail?.dateTime.dateWithMonthOnly ?? '';
        final String time = widget.message.visitingDetail?.visitingTime ?? '';
        final String meet = post?.meetUpLocation?.address ?? '';
        final StatusType status =
            widget.message.visitingDetail?.status ?? StatusType.inActive;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: EdgeInsets.all(widget.showButtons ? 0 : 16),
          decoration: BoxDecoration(
            borderRadius: widget.showButtons
                ? const BorderRadius.vertical(bottom: Radius.circular(0))
                : BorderRadius.circular(12),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showButtons)
                VisitingMessageTileUpdateButtonsWidget(
                    message: widget.message, post: post),

              Container(
                  child: expanded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            VisitingTileStatusWidget(status: status),
                            Flexible(
                              child: Text(
                                maxLines: 1,
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : null),
              // Details Row
              VisitingCardDetailWidget(
                status: status,
                meet: meet,
                expanded: expanded,
                imageUrl: imageUrl,
                currency: currency,
                price: price,
                date: date,
                time: time,
              ),

              if (expanded) VisitingTileTags(post: post),
              if (expanded && widget.showButtons)
                Text('we_looke_forward_to_seeing_you'.tr(),
                    style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      },
    );
  }
}

class VisitingTileStatusWidget extends StatelessWidget {
  const VisitingTileStatusWidget({
    required this.status,
    super.key,
  });

  final StatusType status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('\u25CF ${status.code.tr()}',
          style: TextStyle(
              fontSize: 8, color: status.color, fontWeight: FontWeight.bold)),
    );
  }
}

class VisitingCardDetailWidget extends StatelessWidget {
  const VisitingCardDetailWidget({
    required this.expanded,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
    required this.meet,
    super.key,
  });

  final bool expanded;
  final String imageUrl;
  final String currency;
  final double price;
  final String date;
  final String time;
  final StatusType status;
  final String meet;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Left image block with animated size
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 80,
          height: 80,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  size: double.infinity,
                  imageURL: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Price badge fades/slides in
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 4,
                right: 4,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: expanded ? 1.0 : 0.0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${CountryHelper.currencySymbolHelper(currency)} $price',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Right detail block with animated height
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: expanded
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: <Widget>[
                // Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Label appears with size animation
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: expanded
                          ? Text('${'date'.tr()}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500))
                          : const SizedBox.shrink(),
                    ),
                    Flexible(
                      child: Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    // Status badge only when collapsed
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: !expanded
                          ? VisitingTileStatusWidget(status: status)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Time row
                Row(
                  children: <Widget>[
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: expanded
                          ? Text('${'time'.tr()}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500))
                          : const SizedBox.shrink(),
                    ),
                    Flexible(
                      child: Text(
                        time,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Meet row only when expanded
                Row(
                  children: <Widget>[
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: expanded
                          ? Text('${'meet'.tr()}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500))
                          : null,
                    ),
                    Flexible(
                      child: Text(
                        meet,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VisitingTileTags extends StatelessWidget {
  const VisitingTileTags({required this.post, super.key});
  final PostEntity? post;

  String yesNo(bool? value) => value == null ? '-' : (value ? 'yes' : 'no');

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          _buildTag(post?.condition.code ?? '***', context),
          if (post?.listID == ListingType.vehicle.json)
            _buildTag(post?.vehicleInfo?.year.toString() ?? '****', context),
          if (post?.listID == ListingType.vehicle.json)
            _buildTag(post?.vehicleInfo?.bodyType ?? '******', context),
          if (post?.listID == ListingType.vehicle.json)
            _buildTag(post?.vehicleInfo?.model ?? '******', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.petInfo?.breed.toString() ?? '****', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.petInfo?.age ?? '******', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.petInfo?.breed ?? '******', context),
          if (post?.listID == ListingType.property.json)
            _buildTag(
                post?.propertyInfo?.propertyCategory ?? '******', context),
          if (post?.listID == ListingType.property.json)
            _buildTag(post?.propertyInfo?.propertyType ?? '******', context),
        ],
      ),
    );
  }

  Widget _buildTag(String text, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 8)),
    );
  }
}
