import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/enums/search_entity_type.dart';
import '../provider/search_provider.dart';
import 'pages/search_post_page.dart';
import 'pages/search_service_page.dart';
import 'pages/search_user_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    // Perform initial fetch for all 3 types
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SearchProvider provider =
          Provider.of<SearchProvider>(context, listen: false);

      // Fetch posts
      if (provider.postResults.isEmpty) {
        await provider.searchPosts('');
      }

      // Fetch services
      if (provider.serviceResults.isEmpty) {
        await provider.searchServices('');
      }

      // Fetch users
      if (provider.userResults.isEmpty) {
        await provider.searchUsers('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'search'.tr(),
          style: TextTheme.of(context).titleMedium,
        ),
        centerTitle: true,
      ),
      body: Consumer<SearchProvider>(
        builder:
            (BuildContext context, SearchProvider provider, Widget? child) =>
                Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CustomToggleSwitch<SearchEntityType>(
                verticalPadding: 6,
                isShaded: false,
                unseletedBorderColor: ColorScheme.of(context).outlineVariant,
                unseletedTextColor: ColorScheme.of(context).onSurface,
                borderWidth: 1,
                labels: SearchEntityType.values,
                labelStrs: <String>[
                  'posts'.tr(),
                  'services'.tr(),
                  'accounts'.tr()
                ],
                labelText: '',
                initialValue: provider.currentType,
                onToggle: (SearchEntityType value) {
                  provider.switchType(value);
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: provider.currentType.index,
                  children: const <Widget>[
                    SearchPostsSection(),
                    SearchServicesSection(),
                    SearchUsersSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
