import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/signup_provider.dart';

class SignupPhotoVerificationPage extends StatelessWidget {
  const SignupPhotoVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
        builder: (BuildContext context, SignupProvider pro, _) {
      return SingleChildScrollView(
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'photo_verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ).tr(),
            Text(
              'photo_verification_subtitle',
              textAlign: TextAlign.center,
              style: TextTheme.of(context).bodySmall,
            ).tr(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: pro.attachment == null
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primaryColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.3),
                                    // border: Border.all(color: AppTheme.primaryColor),
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  CupertinoIcons.person_badge_plus,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text('upload_selfie_verification',
                                      style: TextTheme.of(context).titleSmall)
                                  .tr(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'upload_selfie_description'.tr(),
                                  style: TextTheme.of(context)
                                      .bodySmall
                                      ?.copyWith(
                                          color: ColorScheme.of(context)
                                              .outlineVariant),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: CustomElevatedButton(
                                    title: 'take_photo'.tr(),
                                    textStyle: TextTheme.of(context)
                                        .bodySmall
                                        ?.copyWith(
                                            color: ColorScheme.of(context)
                                                .onPrimary),
                                    isLoading: false,
                                    onTap: () {
                                      pro.setImage(context,
                                          type: AttachmentType.image);
                                    }),
                              )
                            ],
                          ),
                        )
                      : Image.file(File(pro.attachment?.file.path ?? ''))),
            ),
            Text(
              'photo_verification_policy',
              textAlign: TextAlign.center,
              style: TextTheme.of(context).bodySmall,
            ).tr(),
            CustomElevatedButton(
                title: 'verify_photo'.tr(),
                isLoading: pro.isLoading,
                onTap: () => pro.onNext(context)),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
