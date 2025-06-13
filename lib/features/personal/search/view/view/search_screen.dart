import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/params/search_enum.dart';
import '../provider/search_provider.dart';
import '../widget/search_bar_widget.dart';
import '../widget/search_result_section.dart';
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
    12,
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

