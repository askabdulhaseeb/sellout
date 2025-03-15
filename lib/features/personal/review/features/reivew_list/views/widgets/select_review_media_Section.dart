import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.selectedMedia.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder<Uint8List?>(
                            future: provider.selectedMedia[index].thumbnailData,
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              if (!snapshot.hasData || snapshot.data == null) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                width: 80,
                                height: 80,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: MemoryImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
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
