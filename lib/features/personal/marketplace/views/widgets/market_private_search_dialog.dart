import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../providers/marketplace_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void showPrivateSearchDialog(BuildContext context) {
  final MarketPlaceProvider pro = Provider.of<MarketPlaceProvider>(
    context,
    listen: false,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  const Spacer(),
                  Text(
                    'private'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),

              // InDevMode(
              //   child: CustomTextFormField(
              //     labelText: 'username'.tr(),
              //     controller: pro.usernameController,
              //   ),
              // ),
              CustomTextFormField(
                fieldPadding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 32.0,
                ),
                labelText: 'access_code'.tr(),
                controller: pro.accessCodeController,
              ),
              CustomElevatedButton(
                isLoading: false,
                onTap: () {
                  pro.loadPrivatePost(context);
                },
                title: 'search'.tr(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
