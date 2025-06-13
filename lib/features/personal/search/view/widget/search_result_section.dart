
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/search_provider.dart';
import 'user_tile.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../../services/views/widgets/service_card/service_card.dart';
class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    required this.selectedFilter, required this.scrollController, super.key,
  });
  final String selectedFilter;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final SearchProvider provider = Provider.of<SearchProvider>(context);

    if (provider.isLoading && provider.searchResults == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }
    if (provider.searchResults == null) {
      return const Center(child: Text('No results yet.'));
    }

    if (selectedFilter == 'Posts') {
      final List<PostEntity> posts = provider.searchResults!.posts ?? <PostEntity>[];
      if (posts.isEmpty) return const Center(child: Text('No posts found.'));
      return GridView.builder(
        controller: scrollController,
        itemCount: posts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, int index) => PostGridViewTile(post: posts[index]),
      );
    } else if (selectedFilter == 'Services') {
      final List<ServiceEntity> services = provider.searchResults!.services ?? <ServiceEntity>[];
      if (services.isEmpty) return const Center(child: Text('No services found.'));
      return ListView.builder(
        controller: scrollController,
        itemCount: services.length,
        itemBuilder: (_, int index) => ServiceCard(service: services[index]),
      );
    } else if (selectedFilter == 'Users') {
      final List<UserEntity> users = provider.searchResults!.users ?? <UserEntity>[];
      if (users.isEmpty) return const Center(child: Text('No users found.'));
      return ListView.builder(
        controller: scrollController,
        itemCount: users.length,
        itemBuilder: (_, int index) => UserTile(user: users[index]),
      );
    }
    return const Center(child: Text('Unknown filter selected.'));
  }
}
