import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_icon_button.dart';
import '../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/add_service_provider.dart';

class AddServiceAttachmentSection extends StatelessWidget {
  const AddServiceAttachmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProvider>(
        builder: (BuildContext context, AddServiceProvider pro, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomElevatedButton(
            title:
                '+ ${'add'.tr()} ${'photos'.tr()} (${pro.attachments.length}/10)',
            // border: Border.all(color: Theme.of(context).primaryColor),
            bgColor:  Theme.of(context).primaryColor.withValues(alpha: 0.1),
            textColor: Theme.of(context).primaryColor,
            isLoading: false,
            onTap: () async => await pro.addPhotos(context),
          ),
          // const SizedBox(height: 8),
          if (pro.attachments.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ListView.builder(
                itemCount: pro.attachments.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  final PickedAttachment attach = pro.attachments[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              attach.file,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                          CustomIconButton(
                            icon: Icons.delete,
                            iconColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.all(4),
                            bgColor: Colors.white,
                            onPressed: () async => pro.removePhoto(attach),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              'mobile_service'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('mobile_service_description'.tr()),
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
        ],
      );
    });
  }
}
