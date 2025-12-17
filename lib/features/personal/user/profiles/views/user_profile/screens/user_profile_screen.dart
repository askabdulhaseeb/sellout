import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../data/sources/local/local_user.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/user_profile_grid_section.dart';
import '../widgets/user_profile_grid_type_selection_section.dart';
import '../widgets/user_profile_header_section.dart';
import '../widgets/user_profile_score_section.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(LocalUser().userEntity(uid)?.username.toUpperCase() ?? ''),
      ),
      body: FutureBuilder<DataState<UserEntity?>?>(
        future: Provider.of<UserProfileProvider>(context, listen: false)
            .getUserByUid(uid),
        initialData: LocalUser().userState(uid),
        builder: (BuildContext context,
            AsyncSnapshot<DataState<UserEntity?>?> snapshot) {
          final UserEntity? user = snapshot.data?.entity;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                UserProfileHeaderSection(user: user),
                UserProfileScoreSection(user: user),
                const UserProfileGridTypeSelectionSection(),
                UserProfileGridSection(user: user),
              ],
            ),
          );
        },
      ),
    );
  }
}
