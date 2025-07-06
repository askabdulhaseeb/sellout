import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/choicechip_section/choicechip_section.dart';
import '../widgets/marketplace_top_section.dart';

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
      body: Consumer<MarketPlaceProvider>(
        builder: (BuildContext context, MarketPlaceProvider pro, _) {
          return const CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(child: MarketPlaceTopSection()),
              SliverToBoxAdapter(
                child: MarketChoiceChipSection(),
              ),
            ],
          );
        },
      ),
    );
  }
}
