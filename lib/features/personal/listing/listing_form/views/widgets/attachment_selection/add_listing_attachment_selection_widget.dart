import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/add_listing_form_provider.dart';
import 'add_listing_attachment_selction_button.dart';
import 'add_listing_picked_attachment_tile.dart';

class AddListingAttachmentSelectionWidget extends StatelessWidget {
  const AddListingAttachmentSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        final List<dynamic> allAttachments = <dynamic>[
          ...formPro.attachments,
          if (formPro.post?.fileUrls != null) ...formPro.post!.fileUrls,
        ];
        final bool hasAttachments = allAttachments.isNotEmpty;
        return Column(
          spacing: AppSpacing.vXs,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AddListingAttachmentSelectionButton(),
            if (!hasAttachments)
              _EmptyAttachmentPlaceholder(formPro: formPro)
            else
              _AttachmentList(allAttachments: allAttachments),
          ],
        );
      },
    );
  }
}

/// 📦 Empty state view
class _EmptyAttachmentPlaceholder extends StatelessWidget {
  const _EmptyAttachmentPlaceholder({required this.formPro});

  final AddListingFormProvider formPro;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => formPro.setImages(context, type: AttachmentType.image),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Column(
          spacing: AppSpacing.vMd,
          children: <Widget>[
            Text(
              'no_item_selected'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                '${'photos'.tr()}: ${formPro.attachments.length}/${formPro.listingType?.noOfPhotos}, '
                '${'videos'.tr()}: 0/1 '
                '${'choose_main_photo_video_to_best_showcase'.tr()}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🖼️ Attachment list view
class _AttachmentList extends StatelessWidget {
  const _AttachmentList({required this.allAttachments});

  final List<dynamic> allAttachments;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.vSm),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: allAttachments.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.hSm),
          itemBuilder: (BuildContext context, int index) {
            final dynamic item = allAttachments[index];

            if (item is PickedAttachment) {
              return ListingAttachmentTile(attachment: item);
            } else if (item is AttachmentEntity) {
              return ListingAttachmentTile(imageUrl: item);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
