import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../domain/entities/post_entity.dart';
import '../../../../../../../providers/feed_provider.dart';

class PostMakeOfferButton extends StatelessWidget {
  const PostMakeOfferButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    void showOfferBottomSheet(BuildContext context, String startingPrice) {
      TextEditingController priceController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              title: Text(
                'make_an_offer'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 30),
                  Text(
                    '${'starting_price:'.tr()} $startingPrice',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'minimum_offer_price'.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rs. ${post.minOfferAmount}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  CustomTextFormField(
                    prefixText: 'PKR',
                    controller: priceController,
                    hint: 'enter_offer_amount'.tr(),
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onTap: () {
                      Provider.of<FeedProvider>(context, listen: false)
                          .createOffer(context: context,
                              postId: post.postID,
                              offerAmount: double.parse(priceController.text),
                              currency: 'PKR',
                              quantity: 1,
                              listId: post.listID);
                    },
                    title: 'Enter',
                    isLoading: false,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return CustomElevatedButton(
      onTap: () => showOfferBottomSheet(context, post.price.toString()),
      title: 'make_an_offer'.tr(),
      isLoading: false,
    );
  }
}
