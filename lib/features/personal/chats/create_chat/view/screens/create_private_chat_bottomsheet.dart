import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../core/sources/data_state.dart';
import '../provider/create_private_chat_provider.dart';

class CreatePrivateChatBottomsheet extends StatelessWidget {
  CreatePrivateChatBottomsheet({super.key});
  final GetUserByUidUsecase getUserByUidUsecase = GetUserByUidUsecase(
    locator(),
  );

  @override
  Widget build(BuildContext context) {
    final List<SupporterDetailEntity> supporters =
        LocalAuth.currentUser?.supporters ?? <SupporterDetailEntity>[];
    final CreatePrivateChatProvider provider =
        Provider.of<CreatePrivateChatProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(onPressed: () => Navigator.pop(context)),
          title: Text(
            'start_chat'.tr(),
            style: TextTheme.of(context).titleMedium,
          ),
        ),
        body: Column(
          children: [
            const EmptyPageWidget(icon: CupertinoIcons.chat_bubble),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: supporters.length,
                itemBuilder: (BuildContext context, int index) {
                  final SupporterDetailEntity supporter = supporters[index];
                  final String userId = supporter.userID;

                  return FutureBuilder<DataState<UserEntity?>>(
                    future: getUserByUidUsecase(userId),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<DataState<UserEntity?>> snapshot,
                        ) {
                          // SKELETON LOADING
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  // Avatar skeleton
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Text skeleton
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 14,
                                          color: Colors.grey.shade300,
                                          margin: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                        ),
                                        Container(
                                          height: 12,
                                          width: 100,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Button skeleton
                                  Container(
                                    width: 60,
                                    height: 35,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            );
                          }

                          // NULL CHECKS
                          if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.entity == null) {
                            return ListTile(
                              title: Text('user_not_found'.tr()),
                              leading: const Icon(Icons.error_outline),
                            );
                          }

                          final UserEntity user = snapshot.data!.entity!;

                          return ListTile(
                            minTileHeight: 70,
                            leading: ProfilePhoto(
                              size: 25,
                              url: user.profilePhotoURL,
                              placeholder: user.displayName,
                            ),
                            title: Text(
                              user.displayName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextTheme.of(context).bodyMedium,
                            ),
                            trailing: SizedBox(
                              height: 45,
                              width: 60,
                              child: CustomElevatedButton(
                                padding: const EdgeInsets.all(0),
                                textStyle: TextTheme.of(context).bodySmall
                                    ?.copyWith(
                                      color: ColorScheme.of(context).onPrimary,
                                    ),
                                onTap: () {
                                  provider.startPrivateChat(context, userId);
                                },
                                title: 'chat'.tr(),
                                isLoading: provider.isLoading,
                              ),
                            ),
                          );
                        },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
