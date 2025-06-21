import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/params/search_enum.dart';
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
  Widget build(BuildContext context) {
    //   final SearchProvider provider =
    //       Provider.of<SearchProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('search'.tr())),
      body: Consumer<SearchProvider>(
        builder:
            (BuildContext context, SearchProvider provider, Widget? child) =>
                Column(
          children: <Widget>[
            CustomToggleSwitch<SearchEntityType>(
              labels: SearchEntityType.values,
              labelStrs: <String>['posts'.tr(), 'services'.tr(), 'users'.tr()],
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
    );
  }
}
