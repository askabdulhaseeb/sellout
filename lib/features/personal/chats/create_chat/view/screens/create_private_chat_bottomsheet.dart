import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../core/sources/data_state.dart';
import '../provider/create_private_chat_provider.dart';

class CreatePrivateChatBottomsheet extends StatelessWidget {
  CreatePrivateChatBottomsheet({super.key});
  final GetUserByUidUsecase getUserByUidUsecase =
      GetUserByUidUsecase(locator());

  @override
  Widget build(BuildContext context) {
    final List<SupporterDetailEntity> supporters =
        LocalAuth.currentUser?.supporters ?? <SupporterDetailEntity>[];
    final CreatePrivateChatProvider provider =
        Provider.of<CreatePrivateChatProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:
              Text('start_chat'.tr(), style: TextTheme.of(context).titleMedium),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: supporters.length,
          itemBuilder: (BuildContext context, int index) {
            final SupporterDetailEntity supporter = supporters[index];
            final String userId = supporter.userID;

            return FutureBuilder<DataState<UserEntity?>>(
              future: getUserByUidUsecase(userId),
              builder: (BuildContext context,
                  AsyncSnapshot<DataState<UserEntity?>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('...'),
                    leading: CircularProgressIndicator(),
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    user.displayName,
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  trailing: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 45,
                        width: 60,
                        child: CustomElevatedButton(
                          padding: const EdgeInsets.all(0),
                          textStyle: TextTheme.of(context).bodySmall?.copyWith(
                              color: ColorScheme.of(context).onPrimary),
                          onTap: () {
                            provider.startPrivateChat(context, userId);
                          },
                          title: 'chat'.tr(),
                          isLoading: provider.isLoading,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
