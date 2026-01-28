import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/buttons/custom_icon_button.dart';
import '../../../../../../../core/widgets/toggles/custom_toggle_switch.dart';
import '../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../../../../../user/profiles/views/enums/profile_page_tab_type.dart';
import '../../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../provider/promo_provider.dart';

class ChooseLinkedPromoPost extends StatefulWidget {
  const ChooseLinkedPromoPost({super.key});

  @override
  State<ChooseLinkedPromoPost> createState() => _ChooseLinkedPromoPostState();
}

class _ChooseLinkedPromoPostState extends State<ChooseLinkedPromoPost> {
  ProfilePageTabType currentPage = ProfilePageTabType.store;
  late final Future<UserEntity?> userFuture;
  late final Future<DataState<List<PostEntity>>> postsFuture;

  @override
  void initState() {
    super.initState();
    userFuture = LocalUser().user(LocalAuth.uid ?? '');
    postsFuture = _fetchPosts(); // fetch once
  }

  Future<DataState<List<PostEntity>>> _fetchPosts() async {
    final UserEntity? user = await LocalUser().user(LocalAuth.uid ?? '');
    if (user == null) {
      return DataFailer<List<PostEntity>>(CustomException('User not found'));
    }
    return await GetPostByIdUsecase(locator())(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          iconSize: 18,
          margin: const EdgeInsets.all(6),
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios,
        ),
        title: const AppBarTitle(titleKey: 'please_select'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CustomToggleSwitch<ProfilePageTabType>(
                verticalPadding: 8,
                borderWidth: 0,
                containerHeight: 40,
                labels: const <ProfilePageTabType>[
                  ProfilePageTabType.store,
                  ProfilePageTabType.viewing,
                ],
                labelStrs: <String>[
                  ProfilePageTabType.store.code.tr(),
                  ProfilePageTabType.viewing.code.tr(),
                ],
                labelText: '',
                initialValue: currentPage,
                onToggle: (ProfilePageTabType value) {
                  setState(() {
                    currentPage = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              FutureBuilder<DataState<List<PostEntity>>>(
                future: postsFuture, // always same future
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<DataState<List<PostEntity>>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data?.entity == null) {
                        return Center(child: Text('no_posts_found'.tr()));
                      }
                      final List<PostEntity> posts = snapshot.data!.entity!;
                      return PromoGridView(posts: posts, pageType: currentPage);
                    },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoGridView extends StatelessWidget {
  const PromoGridView({required this.posts, required this.pageType, super.key});

  final List<PostEntity> posts;
  final ProfilePageTabType pageType;

  @override
  Widget build(BuildContext context) {
    final List<PostEntity> sorted = List.of(
      posts,
    )..sort((PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));

    final List<PostEntity> filteredPosts = sorted.where((PostEntity post) {
      final ListingType listing = ListingType.fromJson(post.listID);
      if (pageType == ProfilePageTabType.store) {
        return ListingType.storeList.contains(listing);
      } else {
        return ListingType.viewingList.contains(listing);
      }
    }).toList();

    if (filteredPosts.isEmpty) {
      return Center(child: Text('no_posts_found'.tr()));
    }
    return GridView.builder(
      itemCount: filteredPosts.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            final PromoProvider pro = Provider.of<PromoProvider>(
              context,
              listen: false,
            );
            pro.setPost(filteredPosts[index]);
            pro.setRefernceID(
              filteredPosts[index].postID,
              'post_attachment',
              filteredPosts[index].listID,
            );
            Navigator.pop(context);
          },
          child: AbsorbPointer(
            child: PostGridViewTile(post: filteredPosts[index]),
          ),
        );
      },
    );
  }
}
