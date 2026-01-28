import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/text_display/empty_page_widget.dart';
import '../../../../../../../core/widgets/loaders/post_grid_loader.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../enums/profile_grid_state.dart';
import '../../providers/base_profile_posts_provider.dart';
import '../subwidgets/post_grid_view_tile.dart';

class ProfilePostsGridView<T extends BaseProfilePostsProvider>
    extends StatelessWidget {
  const ProfilePostsGridView({
    this.childAspectRatio = 0.6,
    this.emptyIcon,
    this.emptyMessage,
    this.errorRetryLabel,
    this.showStartSellingButton = false,
    this.onStartSelling,
    super.key,
  });

  final double childAspectRatio;
  final IconData? emptyIcon;
  final String? emptyMessage;
  final String? errorRetryLabel;
  final bool showStartSellingButton;
  final VoidCallback? onStartSelling;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, T provider, _) {
        return _buildContent(context, provider);
      },
    );
  }

  Widget _buildContent(BuildContext context, T provider) {
    switch (provider.state) {
      case ProfileGridState.initial:
      case ProfileGridState.loading:
        return const PostGridLoader();
      case ProfileGridState.error:
        return _buildEmptyWidget(context);
      case ProfileGridState.empty:
        return _buildEmptyWidget(context);
      case ProfileGridState.loaded:
        return _buildGridView(provider.posts!);
    }
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          EmptyPageWidget(
            icon: emptyIcon ?? CupertinoIcons.photo,
            childBelow: Text(emptyMessage ?? 'no_posts_found'.tr()),
          ),
          if (showStartSellingButton) ...<Widget>[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onStartSelling,
              child: Text('start_selling'.tr()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridView(List<PostEntity> posts) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return PostGridViewTile(post: posts[index]);
      },
    );
  }
}
