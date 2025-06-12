import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';
class AttachmentMessageWidget extends StatelessWidget {
  const AttachmentMessageWidget({required this.attachments, super.key});

  final List<AttachmentEntity> attachments;

  @override
  Widget build(BuildContext context) {
    final int totalCount = attachments.length;

    if (totalCount == 1) {
      // ✅ Just one image/video — show full width
      return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<AttachmentDetailScreen>(
                builder: (_) => AttachmentDetailScreen(attachments: attachments),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildMediaContent(attachments.first,context),
          ),
        ),
      );
    }

    // ✅ More than 1 attachment — use GridView (with max 4 items shown)
    final int displayCount = totalCount > 4 ? 4 : totalCount;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          final bool isLastVisible = index == 3 && totalCount > 4;
          final int remaining = totalCount - 4;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<AttachmentDetailScreen>(
                  builder: (_) => AttachmentDetailScreen(attachments: attachments),
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildMediaContent(attachments[index],context),
                ),
                if (isLastVisible)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '+$remaining',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaContent(AttachmentEntity attachment,BuildContext context) {
    if (attachment.type == AttachmentType.image) {
      return CustomNetworkImage(size: 200,imageURL:attachment.url, fit: BoxFit.cover);
    } else {
      return Container(decoration: BoxDecoration(color:Theme.of(context).scaffoldBackgroundColor,border: Border.all(color: Theme.of(context).dividerColor),borderRadius: BorderRadius.circular(12)),child: VideoWidget(videoSource: attachment.url, play: false,showTime: true,));
    }
  }
}
class AttachmentDetailScreen extends StatefulWidget {
  const AttachmentDetailScreen({
    required this.attachments, super.key,
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
        title: Text('Attachment ${_currentIndex + 1}/${widget.attachments.length}'),
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
      return Image.network(
        attachment.url,
        fit: BoxFit.contain,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Center(child: Icon(Icons.error));
        },
      );
    } else {
      return VideoWidget(videoSource: attachment.url,showTime: true, play: true);
    }
  }
}