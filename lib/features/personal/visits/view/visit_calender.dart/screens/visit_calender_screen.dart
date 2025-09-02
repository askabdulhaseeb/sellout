import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../providers/visit_calender_provider.dart';
import '../widgets/visit_calender_filters.dart';
import '../widgets/visit_calender_timeline.dart';

class VisitCalenderScreen extends StatefulWidget {
  const VisitCalenderScreen({super.key});
  static String routeName = 'visit-calender';

  @override
  State<VisitCalenderScreen> createState() => _VisitCalenderScreenState();
}

class _VisitCalenderScreenState extends State<VisitCalenderScreen> {
  late String postID;
  DateTime selectedDate = DateTime(2023, 7, 4);
  String selectedView = 'Day';
  String selectedFilter = 'All';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    postID = args?['pid'] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final VisitCalenderProvider provider =
          Provider.of<VisitCalenderProvider>(context, listen: false);
      provider.setPostId(postID);
      provider.getPostVisitings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(titleKey: 'my_appointments'.tr())),
      body: Consumer<VisitCalenderProvider>(
        builder: (BuildContext context, VisitCalenderProvider provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const VisitCalendarFilters(),
                const Divider(height: 1),
                Expanded(
                  child: provider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : VisitTimeline(
                          visits: provider.visits,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
