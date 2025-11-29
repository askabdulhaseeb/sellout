import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import 'attachment_source.dart';

class AttachmentConstants {
  static const double thumbSize = 80.0;
  static const double horizontalMargin = 16.0;
  static const double thumbHeight = 90.0;
}

class AttachmentThumbnails extends StatelessWidget {
  const AttachmentThumbnails({
    required this.sources,
    required this.selectedIndex,
    required this.onSelect,
    required this.controller,
    super.key,
  });

  final List<AttachmentSource> sources;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ScrollController controller;

  void _centerSelected(BuildContext context, int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = AttachmentConstants.thumbSize;
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
    return SizedBox(
      height: AttachmentConstants.thumbHeight,
      child: ListView.builder(
        key: const PageStorageKey<String>('thumbnails_list'),
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: sources.length,
        itemBuilder: (BuildContext context, int index) {
          final AttachmentSource source = sources[index];
          final bool selected = selectedIndex == index;
          return _ThumbnailItemKeepAlive(
            source: source,
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
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final AttachmentSource source;
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
      height: AttachmentConstants.thumbSize,
      width: AttachmentConstants.thumbSize,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          color: Theme.of(context).dividerColor,
          elevation: widget.selected ? 5 : 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.source.isVideo
                ? VideoWidget(
                    square: true,
                    play: false,
                    showTime: true,
                    durationFontSize: 10,
                    videoSource: widget.source.isNetwork
                        ? widget.source.networkUrl!
                        : widget.source.filePath!,
                  )
                : widget.source.isNetwork
                    ? CustomNetworkImage(
                        imageURL: widget.source.networkUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.source.filePath!),
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      ),
    );
  }
}
