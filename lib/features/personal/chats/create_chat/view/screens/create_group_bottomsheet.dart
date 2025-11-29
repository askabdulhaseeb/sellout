import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../provider/create_chat_group_provider.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  State<CreateGroupBottomSheet> createState() => _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  final GetUserByUidUsecase getUserByUidUsecase =
      GetUserByUidUsecase(locator());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int step = 1;
  @override
  Widget build(BuildContext context) {
    final CreateChatGroupProvider provider =
        Provider.of<CreateChatGroupProvider>(context, listen: false);
    final List<SupporterDetailEntity> supporters =
        LocalAuth.currentUser?.supporters ?? <SupporterDetailEntity>[];
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CreateChatGroupProvider>().reset(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: step == 1
            ? _buildChooseMembers(provider, supporters)
            : _buildGroupDetails(provider),
      ),
    );
  }

// Inside _buildChooseMembers
  Widget _buildChooseMembers(CreateChatGroupProvider provider,
      List<SupporterDetailEntity> supporters) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => provider.reset(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('choose_members'.tr(),
              style: TextTheme.of(context).titleMedium),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: supporters.length,
                itemBuilder: (BuildContext context, int index) {
                  final SupporterDetailEntity supporter = supporters[index];
                  final String userId = supporter.userID;

                  return FutureBuilder<DataState<UserEntity?>>(
                    future: getUserByUidUsecase(userId),
                    builder: (BuildContext context,
                        AsyncSnapshot<DataState<UserEntity?>> snapshot) {
                      // SKELETON LOADING
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 14,
                                      color: Colors.grey.shade300,
                                      margin: const EdgeInsets.only(bottom: 6),
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
                              Container(
                                width: 35,
                                height: 35,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        );
                      }

                      // NULL / ERROR CHECKS
                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.entity == null) {
                        return ListTile(
                          leading: const Icon(Icons.error_outline),
                          title: Text('user_not_found'.tr()),
                        );
                      }

                      final UserEntity user = snapshot.data!.entity!;

                      return ListTile(
                        minTileHeight: 70,
                        leading: ProfilePhoto(
                          size: 30,
                          url: user.profilePhotoURL,
                          placeholder: user.displayName,
                        ),
                        title: Text(
                          user.displayName,
                          style: TextTheme.of(context).bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Consumer<CreateChatGroupProvider>(
                          builder: (BuildContext context,
                              CreateChatGroupProvider p, _) {
                            final bool isSelected = p.isSelected(user.uid);
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: IconButton(
                                key: ValueKey<bool>(isSelected),
                                icon: Icon(
                                  isSelected
                                      ? Icons.cancel_outlined
                                      : Icons.add_circle_outline,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  p.toggleSupporter(user.uid);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: Consumer<CreateChatGroupProvider>(
                builder:
                    (BuildContext context, CreateChatGroupProvider pro, _) =>
                        Column(
                  children: <Widget>[
                    if (pro.selectedUserIds.length >= 2)
                      CustomElevatedButton(
                        isLoading: false,
                        onTap: () => setState(() => step = 2),
                        title: 'next'.tr(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupDetails(CreateChatGroupProvider provider) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => provider.reset(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              setState(() => step = 1);
            },
          ),
          centerTitle: true,
          title: Text('group_details'.tr(),
              style: TextTheme.of(context).titleMedium),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          provider.setImages(context,
                              type: AttachmentType.image);
                        },
                        child: IgnorePointer(
                          child: CustomTextFormField(
                              readOnly: true,
                              hint: 'group_photo_hint'.tr(),
                              controller: TextEditingController(),
                              contentPadding: const EdgeInsets.all(6),
                              prefixIcon: Consumer<CreateChatGroupProvider>(
                                builder: (BuildContext context,
                                        CreateChatGroupProvider pro,
                                        Widget? child) =>
                                    Container(
                                  padding: const EdgeInsets.all(4.0),
                                  margin: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                    ),
                                  ),
                                  child: provider.attachments.isNotEmpty
                                      ? ClipOval(
                                          child: Image.file(
                                            File(pro
                                                .attachments.first.file.path),
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.camera_alt, size: 30),
                                ),
                              )),
                        ),
                      ),
                      CustomTextFormField(
                        labelText: 'group_name'.tr(),
                        controller: provider.groupTitle,
                        validator: (String? value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'group_name_required'.tr()
                                : null,
                      ),
                      CustomTextFormField(
                        labelText: 'group_description'.tr(),
                        controller: provider.groupDescription,
                        validator: (String? value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'group_description_required'.tr()
                                : null,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              left: 16,
              right: 16,
              child: CustomElevatedButton(
                isLoading: provider.isLoading,
                title: 'Create Group'.tr(),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    provider.createChat(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
