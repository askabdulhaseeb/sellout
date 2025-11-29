import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../data/sources/local/local_user.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_grid_section.dart';
import '../widgets/profile_grid_type_selection_section.dart';
import '../widgets/score_widget_bottomsheets/employment_details_bottomsheet.dart';
import '../widgets/score_widget_bottomsheets/supporter_bottom_sheet.dart';
import '../widgets/subwidgets/support_button.dart';
import '../widgets/user_profile_header_section.dart';

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
                  UserProfileHeaderSection(user: user),
                  UserProfileScoreSection(user: user),
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

class UserProfileScoreSection extends StatelessWidget {
  const UserProfileScoreSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = user?.uid == (LocalAuth.uid ?? '-');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SizedBox(
          height: 35,
          child: Row(
            spacing: 4,
            children: <Widget>[
              if (isMe)
                Expanded(
                  child: _ScoreButton(
                    title: 'details'.tr(),
                    count: '',
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) =>
                            const EmploymentDetailsBottomSheet(),
                      );
                    },
                  ),
                ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporting'.tr(),
                  count: (user?.supportings?.length ?? 0).toString(),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SupporterBottomsheet(
                        supporters: user?.supportings,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporters'.tr(),
                  count: (user?.supporters?.length ?? 0).toString(),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SupporterBottomsheet(
                        supporters: user?.supporters,
                      );
                    },
                  ),
                ),
              ),
              if (!isMe)
                Expanded(
                    child: SupportButton(
                  supporterId: user?.uid ?? '',
                  supportColor: Theme.of(context).primaryColor,
                  supportingColor: Theme.of(context).colorScheme.secondary,
                  supportTextColor: ColorScheme.of(context).onPrimary,
                  supportingTextColor: ColorScheme.of(context).onPrimary,
                ))
            ],
          )),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.title,
    required this.count,
    required this.onPressed,
  });
  final String title;
  final String count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: ShadowContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
