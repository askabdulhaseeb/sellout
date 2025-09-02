import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/widgets/custom_network_image.dart';

class SizeChartButtonTile extends StatelessWidget {
  const SizeChartButtonTile({required this.sizeChartURL, super.key});
  final String sizeChartURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorScheme.of(context).outlineVariant)),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(12),
        title: Text(
          'size_chart'.tr(),
          style: TextTheme.of(context)
              .bodyMedium
              ?.copyWith(color: ColorScheme.of(context).outlineVariant),
        ),
        children: <Widget>[
          ConstrainedBox(
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
        ],
      ),
    );
  }
}
