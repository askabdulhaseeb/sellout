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

    useEffect(() {
      if (feedProvider.posts.isEmpty) {
        Future<void>.microtask(() {
          feedProvider.loadInitialFeed(type);
        });
      }
      return null;
    }, const <Object?>[]);
    // Scroll listener for pagination
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 600) {
          feedProvider.loadMoreFeed(type);
        }
      });
      return null;
    }, <Object?>[scrollController]);
    return PersonalScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        controller: scrollController,
        slivers: const <Widget>[
          SliverToBoxAdapter(child: HomePromoListSection()),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          HomePostListSection(),
        ],
      ),
    );
  }
}
