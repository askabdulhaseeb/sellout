import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../core/widgets/buttons/custom_icon_button.dart';
import '../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../attachment/domain/entities/attachment_entity.dart';
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
              title: '+ ${'add'.tr()} ${'photos'.tr()}',
              bgColor: Theme.of(context).primaryColor.withValues(alpha: 0.025),
              textColor: Theme.of(context).primaryColor,
              isLoading: false,
              onTap: () async => await pro.addPhotos(context),
            ),
            // const SizedBox(height: 8),
            // if (pro.attachments.isNotEmpty)
            if (pro.attachments.isNotEmpty ||
                (pro.currentService?.attachments.isNotEmpty ?? false))
              AspectRatio(
                aspectRatio: 16 / 9,
                child: pro.attachments.isEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pro.currentService?.attachments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AttachmentEntity? item =
                              pro.currentService?.attachments[index];
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomNetworkImage(
                                      imageURL: item?.url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: pro.attachments.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          final PickedAttachment attach =
                              pro.attachments[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
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
                                    icon: AppStrings.applePayBlack,
                                    iconColor: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(4),
                                    bgColor: Colors.white,
                                    onPressed: () async =>
                                        pro.removePhoto(attach),
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
              contentPadding: const EdgeInsets.all(0),
              value: pro.isMobileService,
              title: Text(
                'mobile_service'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('mobile_service_description'.tr()),
              onChanged: pro.setIsMobileService,
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
