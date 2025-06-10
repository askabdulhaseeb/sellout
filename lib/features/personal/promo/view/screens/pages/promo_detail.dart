import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/video_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../provider/promo_provider.dart';
import '../../widget/choose_post_widget.dart';

class PromoDetailsForm extends StatelessWidget {
  const PromoDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
            SizedBox(
              height: 200,
              width: double.infinity,
              child: VideoWidget(videoSource: pro.attachment?.file, showTime: true),
            ),
            const SizedBox(height: 20),
            // Title
            CustomTextFormField(
              controller: pro.title,
              showSuffixIcon: true,
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: Text('${pro.title.text.length}/20'),
              // ),
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
              prefixText: LocalAuth.currency,
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
            CustomElevatedButton(
             isLoading: pro.isLoading,
              onTap: () {
                if (formKey.currentState!.validate()) {
            pro.createPromo();                  }
              },
              
             title:    'upload_promo'.tr(),
              
            ),
          ],
        ),
      ),
    );
  }
}
