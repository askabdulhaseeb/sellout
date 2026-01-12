import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dialogs/post/post_tile_cloth_foot_dialog.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../post/domain/params/add_to_cart_param.dart';
import '../../../../../post/domain/usecase/add_to_cart_usecase.dart';
import '../../../../../post/post_detail/views/screens/post_detail_screen.dart';

class PostGridViewTile extends StatelessWidget {
  const PostGridViewTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        (post.createdBy == (LocalAuth.uid ?? '') ||
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
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      fit: BoxFit.cover,
                      imageURL: post.imageURL,
                    ),
                  ),
                ),
                if (!isMe &&
                    ListingType.storeList.contains(
                      ListingType.fromJson(post.listID),
                    ))
                  PostGridViewTileBasketButton(post: post),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    RatingDisplayWidget(
                      fontSize: 10,
                      size: 12,
                      ratingList: post.listOfReviews ?? <double>[],
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: post.getPriceStr(),
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<String> snapshot,
                          ) {
                            if (!snapshot.hasData) {
                              return const Text('...');
                            }

                            return Text(snapshot.data!);
                          },
                    ),
                  ],
                ),
              ),
              if (isMe)
                Column(
                  spacing: 2,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 2),
                    CustomIconButton(
                      iconSize: 16,
                      iconColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(4),
                      margin: EdgeInsets.zero,
                      bgColor: Theme.of(context).primaryColor.withAlpha(40),
                      icon: AppStrings.selloutPostGridTileEditIcon,
                      onPressed: () {
                        Provider.of<AddListingFormProvider>(
                          context,
                          listen: false,
                        ).startediting(post);
                      },
                    ),
                    // InDevMode(
                    //   child: CustomIconButton(
                    //     iconSize: 16,
                    //     iconColor: Theme.of(context).colorScheme.secondary,
                    //     padding: const EdgeInsets.all(4),
                    //     margin: EdgeInsets.zero,
                    //     bgColor: Theme.of(context)
                    //         .colorScheme
                    //         .secondary
                    //         .withAlpha(40),
                    //     icon: AppStrings.selloutPostGridTilePromoteIcon,
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostGridViewTileBasketButton extends StatelessWidget {
  const PostGridViewTileBasketButton({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    Future<void> addToBasket(BuildContext context, PostEntity post) async {
      try {
        if (post.clothFootInfo?.sizeColors.isNotEmpty == true) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return PostTileClothFootDialog(
                post: post,
                actionType: PostTileClothFootType.add,
              );
            },
          );
        } else {
          final AddToCartUsecase usecase = AddToCartUsecase(locator());
          final DataState<bool> result = await usecase(
            AddToCartParam(post: post, quantity: 1),
          );
          if (result is DataSuccess && context.mounted) {
            AppSnackBar.success(context, 'successfull_add_to_basket'.tr());
          } else {
            AppLog.error(
              result.exception?.message ?? 'AddToCartError',
              name: 'post_add_to_basket_button.dart',
              error: result.exception,
            );
            AppSnackBar.showSnackBar(
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
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      }
    }

    return CustomIconButton(
      borderColor: Theme.of(context).dividerColor,
      iconSize: 14,
      bgColor: ColorScheme.of(context).surface,
      iconColor: Theme.of(context).colorScheme.onSurface,
      icon: AppStrings.selloutAddToCartIcon,
      onPressed: () => addToBasket(context, post),
    );
  }
}
