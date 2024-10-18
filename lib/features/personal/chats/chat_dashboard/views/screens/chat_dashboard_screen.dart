import 'package:flutter/material.dart';

import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../widgets/chat_dashboard_list_seaction.dart';
import '../widgets/chat_dashboard_searchable_widget.dart';
import '../widgets/chat_selectable_page_type_widget.dart';

class ChatDashboardScreen extends StatelessWidget {
  const ChatDashboardScreen({super.key});
  static const String routeName = '/chats';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Column(
        children: <Widget>[
          ChatSelectablePageTypeWidget(),
          ChatDashboardSearchableWidget(),
          ChatDashboardListSeaction(),
        ],
      ),
    );
  }
}
