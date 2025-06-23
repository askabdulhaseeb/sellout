import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dialogs/cart/add_to_cart_dialog.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/domain/params/add_to_cart_param.dart';
import '../../../../../post/domain/usecase/add_to_cart_usecase.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';

class PostGridViewTile extends StatelessWidget {
  const PostGridViewTile({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final bool isMe = (post.createdBy == (LocalAuth.uid ?? '') ||
        post.createdBy == LocalAuth.currentUser?.businessID);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: <String, dynamic>{'pid': post.postID},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 330,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                        fit: BoxFit.cover, imageURL: post.imageURL),
                  ),
                ),
                if (isMe != true) PostGridViewTileBasketButton(post: post)
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: <Widget>[
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        post.title,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    RatingDisplayWidget(
                      fontSize: 10,
                      size: 12,
                      ratingList: post.listOfReviews!,
                    ),
                    Text(
                      post.priceStr,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: <Widget>[
                    if (isMe == true)
                      CustomIconButton(
                        iconSize: 20,
                        iconColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context).primaryColor.withAlpha(40),
                        icon: CupertinoIcons.pencil_circle,
                        onPressed: () {
                          final AddListingFormProvider pro =
                              Provider.of<AddListingFormProvider>(context,
                                  listen: false);
                          pro.reset();
                          pro.setListingType(post.type);
                          pro.setPost(post);
                          pro.updateVariables();
                          Navigator.pushNamed(
                              context, AddListingFormScreen.routeName);
                        },
                      ),
                    if (isMe == true)
                      CustomIconButton(
                        iconSize: 20,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        bgColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(40),
                        icon: CupertinoIcons.speaker,
                        onPressed: () {},
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostGridViewTileBasketButton extends StatelessWidget {
  const PostGridViewTileBasketButton({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    Future<void> addToBasket(BuildContext context, PostEntity post) async {
      try {
        if (post.sizeColors.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddToCartDialog(post: post);
            },
          );
        } else {
          final AddToCartUsecase usecase = AddToCartUsecase(locator());
          final DataState<bool> result = await usecase(
            AddToCartParam(post: post, quantity: 1),
          );
          if (result is DataSuccess) {
            AppSnackBar.showSnackBar(
              // ignore: use_build_context_synchronously
              context,
              'successfull_add_to_basket'.tr(),
              backgroundColor: Colors.green,
            );
          } else {
            AppLog.error(
              result.exception?.message ?? 'AddToCartError',
              name: 'post_add_to_basket_button.dart',
              error: result.exception,
            );
            AppSnackBar.showSnackBar(
              // ignore: use_build_context_synchronously
              context,
              result.exception?.message ?? 'something_wrong'.tr(),
            );
          }
        }
      } catch (e, stackTrace) {
        AppLog.error(
          e.toString(),
          name: 'PostAddToBasketButton._addToBasket',
          error: e,
          stackTrace: stackTrace,
        );
        // ignore: use_build_context_synchronously
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      }
    }

    return CustomIconButton(
        iconColor: Theme.of(context).colorScheme.onPrimary,
        icon: CupertinoIcons.cart,
        onPressed: () {
          addToBasket(context, post);
        });
  }
}
