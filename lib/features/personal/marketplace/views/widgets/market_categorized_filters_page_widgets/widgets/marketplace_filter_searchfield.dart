import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../providers/marketplace_provider.dart';

class MarketFilterSearchField extends StatelessWidget {
  const MarketFilterSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro = Provider.of<MarketPlaceProvider>(
      context,
      listen: false,
    );
    return CustomTextFormField(
      autoFocus: true,
      controller: marketPro.queryController,
      hint: 'search'.tr(),
    );
  }
}
