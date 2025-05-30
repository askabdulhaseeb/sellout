import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/video_widget.dart';
import '../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';

class SelectReviewMediaSection extends StatelessWidget {
  const SelectReviewMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final BorderRadius borderRadius = BorderRadius.circular(12);

    return Consumer<ReviewProvider>(
      builder: (BuildContext context, ReviewProvider provider, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add_photo_video'.tr(),
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 4),
            Text('add_photo_description'.tr()),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8),
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      provider.setImages(context);
                    },
                    borderRadius: borderRadius,
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: Border.all(color: theme.colorScheme.outline),
                        color: theme.colorScheme.surface,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 30),
                      ),
                    ),
                  ),
                  if (provider.attachments.isNotEmpty)
                    ...provider.attachments.map((PickedAttachment media) {
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: media.type == AttachmentType.video
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    AbsorbPointer(
                                      child: VideoWidget(
                                        videoSource: media.file.path,
                                        play: false,
                                        showTime: true,
                                      ),
                                    ),
                                  ],
                                )
                              : Image.file(
                                  media.file,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 100,
                                ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
