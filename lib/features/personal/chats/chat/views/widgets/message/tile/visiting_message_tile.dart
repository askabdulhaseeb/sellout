import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../book_visit/view/widgets/visiting_update_buttons_widget.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class VisitingMessageTile extends StatefulWidget {
  const VisitingMessageTile({
    required this.message,
    required this.showButtons,
    this.isExpanded = false,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;
  final bool? isExpanded;

  @override
  State<VisitingMessageTile> createState() => _VisitingMessageTileState();
}

class _VisitingMessageTileState extends State<VisitingMessageTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(widget.message.visitingDetail?.postID ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        final String imageUrl = post?.fileUrls.first.url ?? '';
        final String title = post?.title ?? 'Test Vehicle';
        final String currency =
            widget.message.offerDetail?.currency ?? post?.currency ?? '£';
        final num price =
            widget.message.offerDetail?.price ?? post?.price ?? 25000;
        final String date =
            widget.message.visitingDetail?.dateTime.dateWithMonthOnly ??
                '22nd September 2025';
        final String time =
            widget.message.visitingDetail?.visitingTime ?? '11:30 AM';

        return AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showButtons)
                VisitingMessageTileUpdateButtonsWidget(
                  message: widget.message,
                  post: post,
                ),
              // HEADER
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('pending'.tr(),
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black87)),
              ),
              const SizedBox(height: 12),
              // IMAGE + BOOKING DETAILS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // IMAGE with price badge
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 100,
                            child: CustomNetworkImage(
                              size: double.infinity,
                              imageURL: imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Flexible(
                              child: Text(
                                '${CountryHelper.currencySymbolHelper(currency)} $price',
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Flexible(
                            child: Text(title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // BOOKING DETAILS
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('your_booking_details'.tr(),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text('${'date'.tr()}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            Expanded(
                              child: Text(date,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('${'time'.tr()}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            Text(time,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // TAGS - fallback to static if post has no tags
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: <Widget>[
                    _buildTag('New'),
                    _buildTag('Year 2025'),
                    _buildTag(post?.brand ?? 'Lexus'),
                    _buildTag(post?.model ?? 'Model 2025'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // FOOTER MESSAGE
              Text('we_looke_forward_to_seeing_you'.tr(),
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
