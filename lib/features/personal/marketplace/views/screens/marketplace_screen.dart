import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/marketplace_provider.dart';
import 'pages/market_categorized_filteration_page.dart';
import 'pages/marketplace_main_page.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});
  static const String routeName = '/marketplace';

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  @override
  void initState() {
    super.initState();
    // Load all posts (represented by empty json string)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketPlaceProvider>().loadChipsPosts('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: SingleChildScrollView(
        child: Consumer<MarketPlaceProvider>(
          builder: (BuildContext context, MarketPlaceProvider pro, _) {
            if (pro.marketplaceCategory == null) {
              return const MarketPlaceMainPage();
            } else {
              return const MarketCategorizedFilterationPage();
            }
          },
        ),
      ),
    );
  }
}
