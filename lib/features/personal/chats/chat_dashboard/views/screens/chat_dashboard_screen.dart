import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/chat_dashboard_provider.dart';
import '../widgets/chat_dashboard_list_seaction.dart';
import '../widgets/chat_dashboard_searchable_widget.dart';
import '../widgets/chat_selectable_page_type_widget.dart';

class ChatDashboardScreen extends StatefulWidget {
  const ChatDashboardScreen({super.key});
  static const String routeName = '/chats';
  @override
  State<ChatDashboardScreen> createState() => _ChatDashboardScreenState();
}

class _ChatDashboardScreenState extends State<ChatDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChatDashboardProvider>(context, listen: false).getChats();
  }

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          AppBarTitle(titleKey: 'messages'),
          SizedBox(
            height: 8,
          ),
          ChatSelectablePageTypeWidget(),
          ChatDashboardSearchableWidget(),
          ChatDashboardListSeaction(),
        ],
      ),
    ));
  }
}
