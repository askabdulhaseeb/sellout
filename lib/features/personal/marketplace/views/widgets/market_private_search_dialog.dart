import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_snakebar.dart';
import '../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../providers/marketplace_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void showPrivateSearchDialog(BuildContext context) {
  final MarketPlaceProvider pro =
      Provider.of<MarketPlaceProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              Text(
                'private'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              InDevMode(
                child: CustomTextFormField(
                  labelText: 'username'.tr(),
                  controller: pro.usernameController,
                ),
              ),
              CustomTextFormField(
                labelText: 'access_code'.tr(),
                controller: pro.accessCodeController,
              ),
              CustomElevatedButton(
                isLoading: false,
                onTap: () async {
                  final bool postAvailble = await pro.loadPrivatePost(context);
                  if (!postAvailble) {
                    AppSnackBar.showSnackBar(context, 'no_post_found');
                  }
                },
                title: 'start_search'.tr(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
