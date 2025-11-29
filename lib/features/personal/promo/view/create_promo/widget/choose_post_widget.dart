import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../provider/promo_provider.dart';
import '../screens/pages/choose_linked_post_screen.dart';

class ChoosePostForPromoWidget extends StatelessWidget {
  const ChoosePostForPromoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<ChooseLinkedPromoPost>(
                builder: (BuildContext context) =>
                    const ChooseLinkedPromoPost()));
      },
      child: Consumer<PromoProvider>(
        builder: (BuildContext context, PromoProvider pro, _) {
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
    // final PromoProvider pro = Provider.of<PromoProvider>(context);
    return AbsorbPointer(
      child: CustomTextFormField(
        controller: TextEditingController(),
        labelText: 'link_product'.tr(),
        validator: (String? value) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
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
                    FutureBuilder<String>(
                      future: post.getPriceStr(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('...');
                        }

                        return Text(snapshot.data!);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: CustomElevatedButton(
                  bgColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  isLoading: false,
                  onTap: () => pro.clearPost(),
                  textStyle: TextTheme.of(context).labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
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
