import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/explore_provider.dart';
import '../widgets/explore_categories_section.dart';
import '../widgets/explore_header.dart';
import '../widgets/explore_products_gridview.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  static const String routeName = '/explore';

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final ExploreProvider pro = Provider.of<ExploreProvider>(context, listen: false);

    return PersonalScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            const ExploreHeader(),
            const ExploreCategoriesSection(),
            Align(
              child: InDevMode(
                  child: InkWell(
                onTap: () => pro.fetchLocations(''),
                child: Text(
                  textAlign: TextAlign.start,
                  'Promoted section',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )),
            ),
            const Divider(),
            const ExploreProductsGridview(
              showPersonal: false,
            ),
            const Divider(),
            const ExploreProductsGridview(
              showPersonal: true,
            ),
          ],
        ),
      ),
    );
  }
}
