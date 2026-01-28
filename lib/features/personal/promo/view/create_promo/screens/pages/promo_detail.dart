import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../provider/promo_provider.dart';
import '../../widget/choose_post_widget.dart';

class PromoDetailsForm extends StatelessWidget {
  const PromoDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro =
        Provider.of<PromoProvider>(context, listen: false);
    debugPrint(pro.attachment?.type.json);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                Text('add_promo'.tr(), style: TextTheme.of(context).titleSmall),
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).scaffoldBackgroundColor),
                )
              ],
            ),
            const PromoThumbnailPicker(),
            const SizedBox(height: 20),
            // Title
            CustomTextFormField(
              controller: pro.title,
              showSuffixIcon: true,
              hint: 'title'.tr(),
              maxLength: 20,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Price
            CustomTextFormField(
              controller: pro.price,
              hint: 'price'.tr(),
              prefixText:
                  CountryHelper.currencySymbolHelper(LocalAuth.currency),
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Price is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const ChoosePostForPromoWidget(),
            const SizedBox(height: 30),
            Consumer<PromoProvider>(
              builder: (BuildContext context, PromoProvider promoPro,
                      Widget? child) =>
                  CustomElevatedButton(
                isLoading: promoPro.isLoadig,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await promoPro.createPromo(context);
                    promoPro.errorMessage == '' ? Navigator.pop(context) : null;
                  }
                },
                title: 'upload_promo'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoThumbnailPicker extends StatelessWidget {
  const PromoThumbnailPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(context);
    final String? attachmentPath = pro.attachment?.file.path;
    final bool isImage = attachmentPath != null &&
        (lookupMimeType(attachmentPath)?.startsWith('image/') ?? false);
    return GestureDetector(
      onTap: () {
        pro.pickThumbnailFromGallery(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorScheme.of(context).surfaceContainer,
        ),
        height: 200,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Builder(
            builder: (_) {
              if (isImage) {
                return Image.file(
                  File(attachmentPath),
                  fit: BoxFit.cover,
                );
              }
              final String? thumbPath = pro.thumbNail?.file.path;
              if (thumbPath != null && thumbPath.isNotEmpty) {
                return Image.file(
                  pro.thumbNail!.file,
                  fit: BoxFit.cover,
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image_outlined,
                        size: 50, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to pick a thumbnail',
                      style: TextStyle(color: ColorScheme.of(context).primary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
