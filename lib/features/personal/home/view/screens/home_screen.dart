import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
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

    // Track if we're currently loading to prevent duplicate calls
    final ValueNotifier<bool> isLoadingMore = useValueNotifier<bool>(false);

    // Initial feed load
    useEffect(() {
      if (feedProvider.posts.isEmpty) {
        Future<void>.microtask(() => feedProvider.loadInitialFeed(type));
      }
      return null;
    }, <Object?>[]);

    // Scroll listener for pagination with proper cleanup
    useEffect(() {
      void onScroll() {
        if (isLoadingMore.value) return;

        final ScrollPosition position = scrollController.position;
        if (position.pixels >= position.maxScrollExtent - 400) {
          isLoadingMore.value = true;
          feedProvider.loadMoreFeed(type).whenComplete(() {
            isLoadingMore.value = false;
          });
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, <Object?>[scrollController]);

    return PersonalScaffold(
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          await feedProvider.refreshFeed(type);
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          cacheExtent: 500,
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
