import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/theme/app_theme.dart';
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

  // @override
  // void didUpdateWidget(covariant VisitingMessageTile oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.isExpanded != widget.isExpanded) {
  //     setState(() {
  //       _expanded = widget.isExpanded ?? false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const TextStyle boldStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(widget.message.visitingDetail?.postID ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant)),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _buildCollapsedState(post, boldStyle, context),
            secondChild: _buildExpandedState(post, boldStyle, context),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedState(
      PostEntity? post, TextStyle boldStyle, BuildContext context) {
    return Column(
      key: const ValueKey<String>('collapsed'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.showButtons)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VisitingMessageTileUpdateButtonsWidget(
              message: widget.message,
              post: post,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 70,
                width: 70,
                child: CustomNetworkImage(
                  imageURL: post?.fileUrls.first.url ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Title & booking info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    post?.title ?? 'na',
                    style: boldStyle.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${CountryHelper.currencySymbolHelper(widget.message.offerDetail?.currency ?? post?.currency)} ${widget.message.offerDetail?.price ?? post?.price}',
                    style: boldStyle,
                  ),
                  if (widget.showButtons)
                    SizedBox(
                      child: GestureDetector(
                        child: Text(
                          'see_all'.tr(),
                          style: TextTheme.of(context).labelSmall?.copyWith(
                              decorationColor: AppTheme.primaryColor,
                              color: AppTheme.primaryColor,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => setState(() => _expanded = true),
                      ),
                    )
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Date & Time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.message.visitingDetail?.dateTime.dateWithMonthOnly ??
                        'Date not set',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.message.visitingDetail?.visitingTime ??
                        'Time not set',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedState(
      PostEntity? post, TextStyle boldStyle, BuildContext context) {
    return Column(
      key: const ValueKey<String>('expanded'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.showButtons)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: VisitingMessageTileUpdateButtonsWidget(
              message: widget.message,
              post: post,
            ),
          ),
        Text(
          'your_booking_details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ).tr(),
        Text(
          '${'you_are_booked_in_for_a_visiting_on'.tr()}:',
          style: boldStyle,
        ),
        const SizedBox(height: 4),
        Text(
          widget.message.visitingDetail?.dateTime.dateWithMonthOnly ??
              'Date not set',
          style: boldStyle,
        ),
        Text(
          widget.message.visitingDetail?.visitingTime ?? 'Time not set',
          style: boldStyle,
        ),
        const SizedBox(height: 4),
        const Text(
          'we_looke_forward_to_seeing_you',
          style: TextStyle(fontWeight: FontWeight.w400),
        ).tr(),
        SizedBox(
          width: double.infinity,
          height: 140, // smaller than 180
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(
              imageURL: post?.fileUrls.first.url ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Expanded(child: Text(post?.title ?? 'na', style: boldStyle)),
            Text(
              '${CountryHelper.currencySymbolHelper(widget.message.offerDetail?.currency ?? post?.currency)} ${widget.message.offerDetail?.price ?? post?.price}',
              style: boldStyle,
            ),
          ],
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],
    );
  }
}
