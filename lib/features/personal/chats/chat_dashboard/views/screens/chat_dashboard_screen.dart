import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../providers/chat_dashboard_provider.dart';
import '../widgets/chat_dashboard_list_seaction.dart';
import '../widgets/chat_dashboard_searchable_widget.dart';
import '../widgets/chat_selectable_page_type_widget.dart';

class ChatDashboardScreen extends StatelessWidget {
  const ChatDashboardScreen({super.key});
  static const String routeName = '/chats';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: FutureBuilder<DataState<List<ChatEntity>>>(
          future: Provider.of<ChatDashboardProvider>(context, listen: false)
              .getChats(),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<List<ChatEntity>>> snapshot) {
            return const Column(
              children: <Widget>[
                ChatSelectablePageTypeWidget(),
                ChatDashboardSearchableWidget(),
                ChatDashboardListSeaction(),
              ],
            );
          }),
    );
  }
}
