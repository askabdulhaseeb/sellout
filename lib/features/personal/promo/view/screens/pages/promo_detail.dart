import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/video_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../provider/promo_provider.dart';
import '../../widget/choose_post_dropdown.dart';


class PromoDetailsForm extends StatelessWidget {
  const PromoDetailsForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {final PromoProvider pro =Provider.of<PromoProvider>(context,listen: false);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          // Promo preview
          Row(children: <Widget>[IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new_rounded))],),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: VideoWidget(videoSource: pro.attachment?.file,showTime: true)
          ),
          const SizedBox(height: 20),
          // Name
          CustomTextFormField(
            controller: pro.title,showSuffixIcon:true ,suffixIcon: Padding(padding:const EdgeInsets.all(8),child: Text('${pro.title.text.length}/20',)),
            hint: 'title'.tr(),
            maxLength: 20,
          ),
          const SizedBox(height: 16),
          // Price
          CustomTextFormField(
            controller: pro.price,hint: 'price'.tr(),prefixText: LocalAuth.currency,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
     const   ChoosePostForPromoDropDown(),
          const SizedBox(height: 30),
          // Upload button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: (){},
              child: const Text(
                'Upload Promo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
