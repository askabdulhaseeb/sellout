import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/picked_media_provider.dart';

class PickedMediaDisplayLimitsWidget extends StatelessWidget {
  const PickedMediaDisplayLimitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider mediaPro, _) {
        return Text(
          'Select (${Provider.of<PickedMediaProvider>(context).selectionStr})',
        );
      },
    );
  }
}