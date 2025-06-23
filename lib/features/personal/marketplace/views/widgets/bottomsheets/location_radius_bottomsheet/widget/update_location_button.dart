import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../providers/marketplace_provider.dart';

class UpdateLocationButton extends StatelessWidget {
  const UpdateLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          CustomElevatedButton(
        isLoading: pro.isLoading,
        onTap: () async {
          await pro.loadPosts();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        title: 'Update Location'.tr(),
      ),
    );
  }
}
