import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../services/views/widgets/service_card/service_card.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../../domain/params/search_enum.dart';
import '../provider/search_provider.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = '/search';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> filterOptions = <String>['Posts', 'Services', 'Users'];
  final TextEditingController _query = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'Posts';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  WidgetsBinding.instance.addPostFrameCallback((_) {
  _triggerSearch();
});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final SearchProvider provider = Provider.of<SearchProvider>(context, listen: false);
    provider.loadMore();
  }

void _triggerSearch([String? manualQuery]) {
  final SearchProvider provider = Provider.of<SearchProvider>(context, listen: false);
  final String queryText = manualQuery ?? _query.text;

  // Set params before calling search
  provider.setParams(
    selectedFilter == 'Posts'
        ? SearchEntityType.posts
        : selectedFilter == 'Services'
            ? SearchEntityType.services
            : SearchEntityType.users,
    queryText,
    12, // or your desired page size
  );

  provider.search();
}


  @override
  void dispose() {
    _scrollController.dispose();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  final SearchProvider provider = Provider.of<SearchProvider>(context, listen: false);

    return PopScope(onPopInvokedWithResult: (bool didPop, dynamic result) => provider.reset(),
      child: Scaffold(
        appBar: AppBar(title: Text('search'.tr())),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              CustomToggleSwitch<String>(
                labels: filterOptions,
                labelStrs: filterOptions,
                labelText: '',
                initialValue: selectedFilter,
                onToggle: (String value) {
                  setState(() => selectedFilter = value);
                  _triggerSearch();
                },
              ),
              const SizedBox(height: 10),
              SearchBarWidget(
                queryController: _query,
                onQueryChanged: (String value) => _triggerSearch(value),
                onClearPressed: () {
                  _query.clear();
                  _triggerSearch('');
                },
                hint: 'search'.tr(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SearchResultsWidget(
                  selectedFilter: selectedFilter,
                  scrollController: _scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return  ListTile(leading: ClipRRect(borderRadius: BorderRadius.circular(5),child: CustomNetworkImage(fit: BoxFit.fill,size: 50,imageURL: user.profilePhotoURL,placeholder: user.displayName,)),
      title: Text(user.displayName,style: TextTheme.of(context).titleSmall?.copyWith(),maxLines: 1,overflow: TextOverflow.ellipsis,),
      subtitle: Text(user.username,style: TextTheme.of(context).labelMedium?.copyWith(color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4)),maxLines: 1,overflow: TextOverflow.ellipsis,),
    );
  }
}


class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.queryController, required this.onQueryChanged, required this.onClearPressed, required this.hint, super.key,
  });

  final TextEditingController queryController;
  final Function(String) onQueryChanged;
  final VoidCallback onClearPressed;
  final String hint;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounce;

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onQueryChanged(query.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.queryController,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: widget.onClearPressed,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

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
