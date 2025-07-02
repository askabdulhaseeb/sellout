import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../data/sources/local/local_user.dart';
import '../providers/profile_provider.dart';
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
        future:
            Provider.of<ProfileProvider>(context, listen: false).getUserByUid(),
        builder: (BuildContext context,
            AsyncSnapshot<DataState<UserEntity?>?> snapshot) {
          // Show loader until data is fully fetched
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child:
                  CircularProgressIndicator(), // You can replace this with your custom loader
            );
          }

          final UserEntity? user = snapshot.data?.entity;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ProfileHeaderSection(user: user),
                ProfileScoreSection(user: user),
                ProfileGridTypeSelectionSection(user: user),
                ProfileGridSection(user: user),
              ],
            ),
          );
        },
      ),
    );
  }
}
