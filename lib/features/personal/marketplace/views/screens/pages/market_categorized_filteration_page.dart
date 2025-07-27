import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/market_categorized_filters_page_widgets/filter_container.dart';
import '../../widgets/market_categorized_filters_page_widgets/filter_container_gridview.dart';
import '../../widgets/market_categorized_filters_page_widgets/widgets/market_filter_container_back_button.dart';

class MarketCategorizedFilterationPage extends StatefulWidget {
  const MarketCategorizedFilterationPage({super.key});
  static const String routeName = 'marketplace-catergory-page';

  @override
  State<MarketCategorizedFilterationPage> createState() =>
      _MarketCategorizedFilterationPageState();
}

class _MarketCategorizedFilterationPageState
    extends State<MarketCategorizedFilterationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _init();
    _scrollController.addListener(() {
      final MarketPlaceProvider provider = context.read<MarketPlaceProvider>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        provider.loadMorePosts();
      }
    });
  }

  void _init() async {
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    await marketPro.fetchDropdownListings();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, dynamic result) =>
              marketPro.clearMarketplaceCategory(),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: marketPro.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const GoBAckButtonWidget(),
                            MarketFilterContainer(screenWidth: screenWidth),
                            const MarketPlaceFilterContainerPostsGrid(),
                            if (marketPro.isLoading)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                          ],
                        ),
                ),
              )),
        );
      },
    );
  }
}
