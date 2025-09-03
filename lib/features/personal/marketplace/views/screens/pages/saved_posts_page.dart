import 'package:flutter/material.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../user/profiles/views/widgets/list_types/profile_my_saved_gridview.dart';

class SavedPostsPage extends StatelessWidget {
  const SavedPostsPage({super.key});
  static String routeName = '/my_saved_posts';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'saved_posts'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ProfileMySavedGridview(),
      ),
    );
  }
}
