import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingAttachmentSelectionButton extends StatelessWidget {
  const AddListingAttachmentSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.hXs,
      children: <Widget>[
        button(
            context: context,
            icon: AppStrings.selloutStartListingImageIcon,
            text: 'add_photos'.tr(),
            onPressed: () async => await Provider.of<AddListingFormProvider>(
                        context,
                        listen: false)
                    .setImages(
                  context,
                  type: AttachmentType.image,
                )),
        button(
            context: context,
            icon: AppStrings.selloutStartListingVideoIcon,
            text: 'add_videos'.tr(),
            onPressed: () async => await Provider.of<AddListingFormProvider>(
                        context,
                        listen: false)
                    .setImages(
                  context,
                  type: AttachmentType.video,
                )),
      ],
    );
  }

  Widget button({
    required BuildContext context,
    required String icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    final BorderRadius radius = BorderRadius.circular(8);
    return Expanded(
      child: Opacity(
        opacity: 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
            color: Colors.transparent,
            borderRadius: radius,
          ),
          child: Material(
            borderRadius: radius,
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomSvgIcon(
                        assetPath: icon, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
