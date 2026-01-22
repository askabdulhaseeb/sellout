import 'package:flutter/material.dart';
import '../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../core/enums/listing/core/postage_type.dart';
import '../../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../../data/sources/local/local_cart.dart';
import 'cart_delivery_pickup_toggle.dart';

class CartItemTile extends StatefulWidget {
  const CartItemTile({required this.item, super.key});
  final CartItemEntity item;

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late Future<(PostEntity?, UserEntity?)> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadPostAndSeller(widget.item.postID);
  }

  Future<(PostEntity?, UserEntity?)> _loadPostAndSeller(String postId) async {
    final PostEntity? post = await LocalPost().getPost(postId);
    final UserEntity? seller = await LocalUser().user(post?.createdBy ?? '');
    return (post, seller);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FutureBuilder<(PostEntity?, UserEntity?)>(
      future: _loadFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<(PostEntity?, UserEntity?)> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeleton();
            }
            final PostEntity? post = snapshot.data?.$1;
            return _buildCartTile(post, textTheme);
          },
    );
  }

  Widget _buildSkeleton() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 16,
                  width: 120,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 14,
                  width: 60,
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CartDeliveryPickupToggle(
            showText: false,
            value: PostageType.postageOnly,
            onChanged: (PostageType value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildCartTile(PostEntity? post, TextTheme textTheme) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: post?.imageURL != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    child: CustomNetworkImage(
                      imageURL: post?.imageURL,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.inventory_2_outlined,
                    color: colorScheme.outlineVariant,
                    size: 36,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post?.title ?? '',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  post != null ? '£${post.price.toStringAsFixed(2)}' : '',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                CartDeliveryPickupToggle(
                  value: PostageType.postageOnly,
                  onChanged: (PostageType value) {
                    // TODO: Handle postage type change
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
