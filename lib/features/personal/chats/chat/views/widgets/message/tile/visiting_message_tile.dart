import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../book_visit/view/widgets/visiting_update_buttons_widget.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../providers/chat_provider.dart';

class VisitingMessageTile extends StatefulWidget {
  const VisitingMessageTile({
    required this.message,
    required this.showButtons,
    this.isExpanded = false,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;
  final bool isExpanded;

  @override
  State<VisitingMessageTile> createState() => _VisitingMessageTileState();
}

class _VisitingMessageTileState extends State<VisitingMessageTile> {
  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context);
    final bool expanded = pro.expandVisitingMessage || widget.isExpanded;

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
        final StatusType status =
            widget.message.visitingDetail?.status ?? StatusType.inActive;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showButtons)
                VisitingMessageTileUpdateButtonsWidget(
                    message: widget.message, post: post),
              if (expanded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(status.code.tr(),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87)),
                    ),
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (expanded) const SizedBox(height: 12),
              Row(
                crossAxisAlignment: expanded
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: expanded ? 100 : 60,
                    width: expanded ? 100 : 60,
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
                        if (expanded)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${CountryHelper.currencySymbolHelper(currency)} $price',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: expanded ? 100 : 60,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: expanded
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: <Widget>[
                          if (expanded)
                            Text('${'date'.tr()}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          Text(date,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                          if (expanded)
                            Text('${'time'.tr()}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          Text(time,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (expanded) const SizedBox(height: 12),
              if (expanded) VisitingTileTags(post: post),
              if (expanded) const SizedBox(height: 12),
              if (expanded)
                Text('we_looke_forward_to_seeing_you'.tr(),
                    style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      },
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
            _buildTag(post?.year.toString() ?? '****', context),
          if (post?.listID == ListingType.vehicle.json)
            _buildTag(post?.brand ?? '******', context),
          if (post?.listID == ListingType.vehicle.json)
            _buildTag(post?.model ?? '******', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.petsCategory.toString() ?? '****', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.breed ?? '******', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag(post?.age ?? '******', context),
          if (post?.listID == ListingType.pets.json)
            _buildTag('${'health_checked'.tr()}: ${yesNo(post?.healthChecked)}',
                context),
          if (post?.listID == ListingType.property.json)
            _buildTag(post?.propertyCategory ?? '******', context),
          if (post?.listID == ListingType.property.json)
            _buildTag(post?.propertytype ?? '******', context),
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
