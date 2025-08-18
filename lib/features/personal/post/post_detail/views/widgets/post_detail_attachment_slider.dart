import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/video_widget.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';

class PostDetailAttachmentSlider extends StatefulWidget {
  const PostDetailAttachmentSlider({
    required this.attachments,
    this.showThumbnails = true,
    super.key,
  });

  final List<AttachmentEntity> attachments;
  final bool showThumbnails;

  @override
  State<PostDetailAttachmentSlider> createState() =>
      _PostDetailAttachmentSliderState();
}

class _PostDetailAttachmentSliderState
    extends State<PostDetailAttachmentSlider> {
  late final PageController _pageController;
  late final ScrollController _thumbController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
    _thumbController = ScrollController();
  }

  bool _isVideo(AttachmentEntity attachment) =>
      attachment.type == AttachmentType.video;
  void _onPageChanged(int index) {
    setState(() => selectedIndex = index);

    const double itemWidth = AttachmentThumbnails._thumbSize;
    const double horizontalMargin = 16; // matches your Container margin
    final double availableWidth =
        MediaQuery.of(context).size.width - (horizontalMargin * 2);

    final double maxOffset = _thumbController.position.maxScrollExtent;

    double targetOffset =
        (index * itemWidth) - (availableWidth / 2 - itemWidth / 2);

    if (targetOffset < 0) targetOffset = 0;
    if (targetOffset > maxOffset) targetOffset = maxOffset;

    _thumbController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) {
      return Center(child: Text('no_attachments'.tr()));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            key: const PageStorageKey<String>('main_attachments'),
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.attachments.length,
            itemBuilder: (BuildContext context, int index) {
              final AttachmentEntity attachment = widget.attachments[index];
              return MainAttachmentDisplayKeepAlive(
                attachment: attachment,
                isVideo: _isVideo(attachment),
              );
            },
          ),
        ),
        if (widget.showThumbnails && widget.attachments.length > 1) ...<Widget>[
          const SizedBox(height: 10),
          AttachmentThumbnails(
            attachments: widget.attachments,
            selectedIndex: selectedIndex,
            onSelect: (int index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => selectedIndex = index);
            },
            isVideo: _isVideo,
            controller: _thumbController,
          ),
        ],
      ],
    );
  }
}

class MainAttachmentDisplayKeepAlive extends StatefulWidget {
  const MainAttachmentDisplayKeepAlive({
    required this.attachment,
    required this.isVideo,
    super.key,
  });

  final AttachmentEntity attachment;
  final bool isVideo;

  @override
  State<MainAttachmentDisplayKeepAlive> createState() =>
      _MainAttachmentDisplayKeepAliveState();
}

class _MainAttachmentDisplayKeepAliveState
    extends State<MainAttachmentDisplayKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: widget.isVideo
              ? VideoWidget(videoSource: widget.attachment.url, play: true)
              : CustomNetworkImage(
                  imageURL: widget.attachment.url,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class AttachmentThumbnails extends StatelessWidget {
  const AttachmentThumbnails({
    required this.attachments,
    required this.selectedIndex,
    required this.onSelect,
    required this.isVideo,
    required this.controller,
    super.key,
  });

  final List<AttachmentEntity> attachments;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool Function(AttachmentEntity) isVideo;
  final ScrollController controller;

  static const double _thumbSize = 90;

  void _centerSelected(BuildContext context, int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = _thumbSize;
    final double targetOffset =
        (index * itemWidth) - (screenWidth / 2 - itemWidth / 2);

    controller.animateTo(
      targetOffset.clamp(
        controller.position.minScrollExtent,
        controller.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      child: ListView.builder(
        key: const PageStorageKey<String>('thumbnails_list'),
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (BuildContext context, int index) {
          final AttachmentEntity attachment = attachments[index];
          final bool selected = selectedIndex == index;
          return _ThumbnailItemKeepAlive(
            attachment: attachment,
            isVideo: isVideo(attachment),
            selected: selected,
            onTap: () {
              onSelect(index);
              _centerSelected(context, index);
            },
          );
        },
      ),
    );
  }
}

class _ThumbnailItemKeepAlive extends StatefulWidget {
  const _ThumbnailItemKeepAlive({
    required this.attachment,
    required this.isVideo,
    required this.selected,
    required this.onTap,
  });

  final AttachmentEntity attachment;
  final bool isVideo;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ThumbnailItemKeepAlive> createState() =>
      _ThumbnailItemKeepAliveState();
}

class _ThumbnailItemKeepAliveState extends State<_ThumbnailItemKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: 90,
      width: 90,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          color: Theme.of(context).dividerColor,
          elevation: widget.selected ? 5 : 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.isVideo
                ? VideoWidget(
                    play: false,
                    showTime: true,
                    durationFontSize: 10,
                    videoSource: widget.attachment.url,
                  )
                : CustomNetworkImage(
                    imageURL: widget.attachment.url,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
