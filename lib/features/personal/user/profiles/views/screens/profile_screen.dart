import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../data/sources/local/local_user.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_filter_section.dart';
import '../widgets/profile_grid_section.dart';
import '../widgets/profile_grid_type_selection_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_score_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: FutureBuilder<DataState<UserEntity?>?>(
          future: Provider.of<ProfileProvider>(context, listen: false)
              .getUserByUid(),
          initialData: LocalUser().userState(LocalAuth.uid ?? ''),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>?> snapshot) {
            return const SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ProfileHeaderSection(),
                  ProfileScoreSection(),
                  ProfileGridTypeSelectionSection(),
                  ProfileFilterSection(),
                  ProfileGridSection(),
                ],
              ),
            );
          }),
    );
  }
}
