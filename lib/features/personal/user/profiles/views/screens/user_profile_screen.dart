import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../data/sources/local/local_user.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_filter_section.dart';
import '../widgets/profile_grid_section.dart';
import '../widgets/profile_grid_type_selection_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_score_section.dart';

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
          future: Provider.of<ProfileProvider>(context, listen: false)
              .getUserByUid(uid: uid),
          initialData: LocalUser().userState(LocalAuth.uid ?? ''),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>?> snapshot) {
            final UserEntity? user = snapshot.data?.entity;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeaderSection(user: user),
                  ProfileScoreSection(user: user),
                  ProfileGridTypeSelectionSection(user: user),
                  // ProfileFilterSection(user: user),
                  ProfileGridSection(user: user),
                ],
              ),
            );
          }),
    );
  }
}
