import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';

class MediaPickerScreen extends StatefulWidget {
  const MediaPickerScreen({super.key});
  static const String routeName = '/pick-media';

  @override
  State<MediaPickerScreen> createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('photo_videos'.tr())),
      body: Column(
        children: <Widget>[
          Consumer<ReviewProvider>(
            builder:
                (BuildContext context, ReviewProvider provider, Widget? child) {
              return provider.selectedattachment.isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      height: 200,
                      width: 300,
                      margin: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.selectedattachment.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PickedAttachment media =
                              provider.selectedattachment[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(media.file,
                                width: 100, height: 100, fit: BoxFit.cover),
                          );
                        },
                      ),
                    );
            },
          ),
          Expanded(
            child: Consumer<ReviewProvider>(
              builder: (BuildContext context, ReviewProvider provider,
                  Widget? child) {
                return provider.attachments.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: provider.attachments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PickedAttachment media =
                              provider.attachments[index];
                          final bool isSelected =
                              provider.selectedattachment.contains(media);
                          return GestureDetector(
                            onTap: () => provider.toggleMediaSelection(media),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.file(media.file, fit: BoxFit.cover),
                                if (isSelected)
                                  Container(
                                    color: Colors.black54,
                                    child: const Icon(Icons.check_circle,
                                        color: Colors.white, size: 30),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
