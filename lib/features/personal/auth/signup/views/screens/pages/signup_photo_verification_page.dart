import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/core/attachment_type.dart';
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
              Text(
                'photo_verification',
                style: TextTheme.of(
                  context,
                ).titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: pro.attachment == null
                        ? Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Icon(
                                  CupertinoIcons.person_badge_plus,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                'upload_selfie_verification',
                                style: TextTheme.of(context).titleSmall,
                              ).tr(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'upload_selfie_description'.tr(),
                                  style: TextTheme.of(context).bodySmall
                                      ?.copyWith(
                                        color: ColorScheme.of(
                                          context,
                                        ).outlineVariant,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: CustomElevatedButton(
                                  title: 'take_photo'.tr(),
                                  textStyle: TextTheme.of(context).bodySmall
                                      ?.copyWith(
                                        color: ColorScheme.of(
                                          context,
                                        ).onPrimary,
                                      ),
                                  isLoading: false,
                                  onTap: () {
                                    pro.setImage(
                                      context,
                                      type: AttachmentType.image,
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              pro.setImage(context, type: AttachmentType.image);
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.file(
                                  File(pro.attachment!.file.path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.45,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              if (pro.attachment != null)
                SizedBox(
                  width: 160,
                  child: CustomElevatedButton(
                    title: 'change_photo'.tr(),
                    isLoading: false,
                    bgColor: Colors.transparent,
                    border: Border.all(color: Theme.of(context).disabledColor),
                    onTap: () {
                      pro.setImage(context, type: AttachmentType.image);
                    },
                  ),
                ),
              Text(
                'photo_verification_policy',
                textAlign: TextAlign.center,
                style: TextTheme.of(context).bodySmall,
              ).tr(),
              SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomElevatedButton(
                      title: 'verify_photo'.tr(),
                      isLoading: pro.isLoading,
                      onTap: () => pro.onNext(context),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
