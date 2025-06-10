import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/promo_provider.dart';
import 'choose_post_bottomsheet.dart';


class ChoosePostForPromoWidget extends StatelessWidget {
  const ChoosePostForPromoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext context) => const ChoosePostBottomSheet(),
        );
      },
      child: Consumer<PromoProvider>(
        builder: (context, pro, _) {
          final PostEntity? selectedPost = pro.post;

          return selectedPost == null
              ? const PostSelectionField()
              : const SelectedPostTile();
        },
      ),
    );
  }
}

class PostSelectionField extends StatelessWidget {
  const PostSelectionField({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(context);

    return AbsorbPointer(
      child: CustomTextFormField(controller: TextEditingController(),
      labelText: 'link_product'.tr(),
        validator: (String? value) {
          if (pro.referenceId.isEmpty) {
            return 'Please select a post';
          }
          return null;
        },
        readOnly: true,
      ),
    );
  }
}


class SelectedPostTile extends StatelessWidget {
  const SelectedPostTile({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(context);
    final PostEntity post = pro.post!;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [  Text(
             'link_product'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  imageURL: post.imageURL,
                 size: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.priceStr,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 80,
                child: CustomElevatedButton(bgColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                
                 isLoading: false,
                 onTap: () => pro.clearPost(),textStyle:TextTheme.of(context).labelMedium?.copyWith(color: AppTheme.primaryColor,),
                 title: 'deselect'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
