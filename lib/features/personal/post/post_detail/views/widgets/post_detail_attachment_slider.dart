import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart'
    as remote;
import '../../../../../attachment/domain/entities/picked_attachment.dart'
    as picked;
import 'attachments/attachment_constants.dart';
import 'attachments/attachment_source.dart';
import 'attachments/attachment_thumbnails.dart' as modular;
import 'attachments/main_attachment_display.dart';

class PostDetailAttachmentSlider extends StatefulWidget {
  PostDetailAttachmentSlider.remote({
    required List<remote.AttachmentEntity> attachments,
    this.showThumbnails = true,
    super.key,
  }) : sources =
            attachments.map(AttachmentSource.fromAttachmentEntity).toList();
  PostDetailAttachmentSlider.picked({
    required List<picked.PickedAttachment> attachments,
    this.showThumbnails = true,
    super.key,
  }) : sources =
            attachments.map(AttachmentSource.fromPickedAttachment).toList();

  const PostDetailAttachmentSlider.sources({
    required this.sources,
    this.showThumbnails = true,
    super.key,
  });

  final List<AttachmentSource> sources;
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

  void _onPageChanged(int index) {
    setState(() => selectedIndex = index);

    const double itemWidth = AttachmentConstants.thumbSize;
    const double horizontalMargin = AttachmentConstants.horizontalMargin;
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
    if (widget.sources.isEmpty) {
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
            itemCount: widget.sources.length,
            itemBuilder: (BuildContext context, int index) {
              final AttachmentSource source = widget.sources[index];
              return _MainAttachmentDisplayKeepAlive(source: source);
            },
          ),
        ),
        if (widget.showThumbnails && widget.sources.length > 1) ...<Widget>[
          const SizedBox(height: 10),
          modular.AttachmentThumbnails(
            sources: widget.sources,
            selectedIndex: selectedIndex,
            onSelect: (int index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => selectedIndex = index);
            },
            controller: _thumbController,
          ),
        ],
      ],
    );
  }
}

class _MainAttachmentDisplayKeepAlive extends StatefulWidget {
  const _MainAttachmentDisplayKeepAlive({
    required this.source,
  });

  final AttachmentSource source;

  @override
  State<_MainAttachmentDisplayKeepAlive> createState() =>
      _MainAttachmentDisplayKeepAliveState();
}

class _MainAttachmentDisplayKeepAliveState
    extends State<_MainAttachmentDisplayKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AttachmentConstants.horizontalMargin, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: MainAttachmentDisplay(
        source: widget.source,
        square: true,
      ),
    );
  }
}
