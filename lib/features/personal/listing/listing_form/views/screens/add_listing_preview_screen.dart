import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/widgets/attachment_slider.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/store_post_button_tile.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/viewing_post_button_tile.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/home_post_header_section.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/home_post_icon_botton_section.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/home_post_title_section.dart';
import '../../../../post/post_detail/views/widgets/post_detail_title_amount_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/item_post_detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/cloth_foot_post_detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/food_drink_post_Detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/pets_post_detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/property_post_detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_details_sections/vehicle_post_detail_section.dart';
import '../../../../post/post_detail/views/widgets/post_detail_attachment_slider.dart';
import '../../../../post/post_detail/views/widgets/attachments/attachment_source.dart';
import '../providers/add_listing_form_provider.dart';

class AddListingPreviewScreen extends StatefulWidget {
  const AddListingPreviewScreen({
    required this.post,
    required this.pickedAttachments,
    super.key,
  });

  final PostEntity post;
  final List<PickedAttachment> pickedAttachments;

  @override
  State<AddListingPreviewScreen> createState() =>
      _AddListingPreviewScreenState();
}

enum _PreviewMode { feed, detail }

class _AddListingPreviewScreenState extends State<AddListingPreviewScreen> {
  _PreviewMode _previewMode = _PreviewMode.feed;

  @override
  Widget build(BuildContext context) {
    final PostEntity previewPost = widget.post;
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(titleKey: 'preview_listing'.tr()),
          centerTitle: true,
          elevation: 2,
        ),
        body: Consumer<AddListingFormProvider>(
          builder: (BuildContext context, AddListingFormProvider provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  CustomToggleSwitch<int>(
                    initialValue: _previewMode == _PreviewMode.feed ? 0 : 1,
                    labels: const <int>[0, 1],
                    labelStrs: <String>[
                      'feed_preview'.tr(),
                      'detail_preview'.tr(),
                    ],
                    labelText: '',
                    onToggle: (int index) {
                      setState(() {
                        _previewMode = index == 0
                            ? _PreviewMode.feed
                            : _PreviewMode.detail;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _previewMode == _PreviewMode.feed
                      ? _FeedPreviewSection(
                          post: previewPost,
                          pickedAttachments: widget.pickedAttachments,
                        )
                      : _DetailPreviewSection(
                          post: previewPost,
                          pickedAttachments: widget.pickedAttachments,
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeedPreviewSection extends StatelessWidget {
  const _FeedPreviewSection({
    required this.post,
    required this.pickedAttachments,
  });

  final PostEntity post;
  final List<PickedAttachment> pickedAttachments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AbsorbPointer(absorbing: true, child: PostHeaderSection(post: post)),
        AttachmentsSlider.mixed(
          remote: post.fileUrls,
          picked: pickedAttachments,
        ),
        AbsorbPointer(
            absorbing: true,
            child: HomePostIconBottonSection(post: post, isPreview: true)),
        HomePostTitleSection(post: post),
        AbsorbPointer(
          absorbing: true,
          child: (post.type == ListingType.pets ||
                  post.type == ListingType.vehicle ||
                  post.type == ListingType.property)
              ? ViewingPostButtonTile(
                  post: post,
                  detailWidget: false,
                )
              : StorePostButtonTile(
                  post: post,
                  detailWidget: false,
                ),
        ),
        const SizedBox(height: AppSpacing.vMd),
        Container(
          height: 4,
          width: double.infinity,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}

class _DetailPreviewSection extends StatelessWidget {
  const _DetailPreviewSection({
    required this.post,
    required this.pickedAttachments,
  });

  final PostEntity post;
  final List<PickedAttachment> pickedAttachments;

  List<AttachmentSource> _sources() {
    return <AttachmentSource>[
      if (post.fileUrls.isNotEmpty)
        ...post.fileUrls.map(AttachmentSource.fromAttachmentEntity),
      if (pickedAttachments.isNotEmpty)
        ...pickedAttachments.map(AttachmentSource.fromPickedAttachment),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<AttachmentSource> sources = _sources();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (sources.isNotEmpty) ...<Widget>[
          PostDetailAttachmentSlider.sources(sources: sources),
          const SizedBox(height: 12),
          PostDetailTitleAmountSection(post: post),
          AbsorbPointer(
            absorbing: true,
            child: (post.type == ListingType.pets ||
                    post.type == ListingType.vehicle ||
                    post.type == ListingType.property)
                ? ViewingPostButtonTile(
                    post: post,
                    detailWidget: false,
                  )
                : StorePostButtonTile(
                    post: post,
                    detailWidget: false,
                  ),
          ),
          const SizedBox(height: AppSpacing.vMd),
        ],
        AbsorbPointer(
          absorbing: true,
          child: post.listID == ListingType.items.json
              ? ItemPostDetailSection(post: post)
              : post.listID == ListingType.clothAndFoot.json
                  ? ClothFootPostDetailSection(post: post)
                  : post.listID == ListingType.foodAndDrink.json
                      ? FoodDrinkPostDetailSection(post: post)
                      : post.listID == ListingType.property.json
                          ? PropertyPostDetailSection(post: post)
                          : post.listID == ListingType.pets.json
                              ? PetsPostDetailSection(post: post)
                              : post.listID == ListingType.vehicle.json
                                  ? VehiclePostDetailSection(post: post)
                                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// End of file
