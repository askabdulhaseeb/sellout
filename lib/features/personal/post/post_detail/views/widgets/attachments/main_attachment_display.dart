import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart'
    as remote;
import 'attachment_source.dart';

class MainAttachmentDisplay extends StatelessWidget {
  factory MainAttachmentDisplay.fromRemote({
    required remote.AttachmentEntity attachment,
    bool square = true,
    Key? key,
  }) =>
      MainAttachmentDisplay(
        key: key,
        source: AttachmentSource.fromAttachmentEntity(attachment),
        square: square,
      );
  const MainAttachmentDisplay({
    required this.source,
    this.square = true,
    super.key,
  });

  final AttachmentSource source;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: source.isVideo
            ? VideoWidget(
                videoSource:
                    source.isNetwork ? source.networkUrl! : source.filePath!,
                play: true,
                showTime: true,
                square: square,
              )
            : source.isNetwork
                ? CustomNetworkImage(
                    imageURL: source.networkUrl,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    source.file!,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
