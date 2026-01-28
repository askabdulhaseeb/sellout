import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/text_display/coming_soon_overlay.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/services_page_provider.dart';
import '../widgets/services_page_type_toggle_section.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  static const String routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User reached near the bottom
      final ServicesPageProvider pro = context.read<ServicesPageProvider>();
      if (!pro.isLoading) {
        pro.loadMoreServices();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            controller: _scrollController,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppBarTitle(titleKey: 'services'),
                ServicesPageTypeToggleSection(),
              ],
            ),
          ),
          ComingSoonOverlay(
            title: 'coming_soon'.tr(),
            subtitle: 'services_coming_soon_subtitle'.tr(),
            icon: CupertinoIcons.hourglass,
          ),
        ],
      ),
    );
  }
}
