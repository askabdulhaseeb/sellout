import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../core/widgets/media/custom_network_image.dart';

class SizeChartButtonTile extends StatelessWidget {
  const SizeChartButtonTile({required this.sizeChartURL, super.key});
  final String sizeChartURL;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      showTrailingIcon: true,
      maintainState: true,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: ColorScheme.of(context).outline),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: ColorScheme.of(context).outline),
      ),
      title: Text(
        'size_chart'.tr(),
        style: TextTheme.of(context).bodyMedium?.copyWith(
          color: ColorScheme.of(context).onSurface.withValues(alpha: 0.6),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.36,
            ),
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  imageURL: sizeChartURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
