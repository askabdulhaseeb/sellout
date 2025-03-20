import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';
import '../screens/media_picker_screen.dart';

class SelectReviewMediaSection extends StatelessWidget {
  const SelectReviewMediaSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
        builder: (BuildContext context, ReviewProvider provider,
                Widget? child) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  textAlign: TextAlign.start,
                  'Add_photo_video'.tr(),
                  style: TextTheme.of(context).titleSmall,
                ),
                Text('add_photo_description'.tr()),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MediaPickerScreen.routeName);
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: Icon(Icons.add)),
                        ),
                      ),
                      Consumer<ReviewProvider>(
                        builder: (BuildContext context, ReviewProvider provider,
                            Widget? child) {
                          return provider.selectedattachment.isEmpty
                              ? const SizedBox.shrink()
                              : Container(
                                  height: 100,
                                  width: 200,
                                  margin: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        provider.selectedattachment.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final PickedAttachment media =
                                          provider.selectedattachment[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: media.type ==
                                                AttachmentType.video
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  AbsorbPointer(
                                                    child: VideoWidget(
                                                        videoUrl:
                                                            media.file.path,
                                                        play: false),
                                                  ), // Video thumbnail
                                                  const Icon(
                                                      Icons.play_circle_fill,
                                                      size: 40,
                                                      color: Colors.white),
                                                ],
                                              )
                                            : Image.file(media.file,
                                                fit: BoxFit.cover),
                                      );
                                    },
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
