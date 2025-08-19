import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
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
    AppLog.info('${LocalAuth.token}', name: "token");

    return const PersonalScaffold(
        body: Column(
      children: <Widget>[
        AppBarTitle(titleKey: 'messages'),
        SizedBox(
          height: 8,
        ),
        ChatSelectablePageTypeWidget(),
        ChatDashboardSearchableWidget(),
        ChatDashboardListSeaction(),
      ],
    ));
  }
}
