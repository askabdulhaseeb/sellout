import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/feed_provider.dart';
import '../widgets/post/home_post_list_section.dart';
import '../widgets/promo/home_promo_list_section.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();
    final FeedProvider feedProvider = context.read<FeedProvider>();
    const String type = 'post';

    // Initial feed load
    useEffect(() {
      if (feedProvider.posts.isEmpty) {
        Future.microtask(() => feedProvider.loadInitialFeed(type));
      }
      return null;
    }, <Object?>[]);

    // Scroll listener for pagination
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 400) {
          feedProvider.loadMoreFeed(type);
        }
      });
      return null;
    }, <Object?>[scrollController]);

    return PersonalScaffold(
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          await feedProvider.refreshFeed(type);
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: const <Widget>[
            SliverToBoxAdapter(child: HomePromoListSection()),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            HomePostListSection(),
          ],
        ),
      ),
    );
  }
}
