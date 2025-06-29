import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../domain/entities/chat/chat_entity.dart';
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
  late Future<DataState<List<ChatEntity>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.delayed(const Duration(milliseconds: 300), () {
      return Provider.of<ChatDashboardProvider>(context, listen: false)
          .getChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: FutureBuilder<DataState<List<ChatEntity>>>(
        future: _future,
        builder: (BuildContext context,
            AsyncSnapshot<DataState<List<ChatEntity>>> snapshot) {
          return const Column(
            children: <Widget>[
              ChatSelectablePageTypeWidget(),
              ChatDashboardSearchableWidget(),
              ChatDashboardListSeaction(),
            ],
          );
        },
      ),
    );
  }
}
