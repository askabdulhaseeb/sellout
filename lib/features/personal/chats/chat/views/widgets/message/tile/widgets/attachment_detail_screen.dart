import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../../../core/widgets/media/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';

class AttachmentDetailScreen extends StatefulWidget {
  const AttachmentDetailScreen({
    required this.attachments,
    super.key,
    this.initialIndex = 0,
  });
  final List<AttachmentEntity> attachments;
  final int initialIndex;

  @override
  State<AttachmentDetailScreen> createState() => _AttachmentDetailScreenState();
}

class _AttachmentDetailScreenState extends State<AttachmentDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${'media'.tr()}: ${_currentIndex + 1}/${widget.attachments.length}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: widget.attachments.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final AttachmentEntity attachment = widget.attachments[index];
              return InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 3,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _buildMediaContent(attachment),
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.attachments.length > 1)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 40),
                onPressed: _currentIndex > 0
                    ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
              ),
            ),
          if (widget.attachments.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 40),
                onPressed: _currentIndex < widget.attachments.length - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(AttachmentEntity attachment) {
    if (attachment.type == AttachmentType.image) {
      return CustomNetworkImage(imageURL: attachment.url, fit: BoxFit.contain);
    } else {
      return VideoWidget(
        videoSource: attachment.url,
        showTime: true,
        play: true,
      );
    }
  }
}
