import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../../../core/widgets/inputs/searchable_textfield.dart';
import '../../../../../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../../../../../core/widgets/text_display/empty_page_widget.dart';
import '../../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../../providers/send_message_provider.dart';
import '../../../../../../../../../user/profiles/data/models/user_model.dart';
import 'contact_export.dart';

class ContactsBottomSheetView extends StatefulWidget {
  const ContactsBottomSheetView({super.key});

  @override
  State<ContactsBottomSheetView> createState() =>
      _ContactsBottomSheetViewState();
}

class _ContactsBottomSheetViewState extends State<ContactsBottomSheetView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  UserEntity? _selectedUser;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final SendMessageProvider provider = Provider.of<SendMessageProvider>(
      context,
      listen: false,
    );
    // First fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.resetUserSearch();
      provider.searchUsers('');
    });

    _scrollController.addListener(() {
      final SendMessageProvider provider = Provider.of<SendMessageProvider>(
        context,
        listen: false,
      );
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          provider.hasMoreUsers &&
          !provider.isUserLoading) {
        provider.loadMoreUsers(_controller.text);
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final SendMessageProvider provider = Provider.of<SendMessageProvider>(
        context,
        listen: false,
      );
      provider.resetUserSearch();
      provider.searchUsers(query);
      if (_selectedUser != null && !provider.users.contains(_selectedUser)) {
        _selectedUser = null;
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro = Provider.of<SendMessageProvider>(
      context,
    );
    final List<UserEntity> users = msgPro.users;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const AppBarTitle(titleKey: 'users'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchableTextfield(
              controller: _controller,
              onChanged: _onSearchChanged,
            ),
          ),
          if (users.isEmpty && !msgPro.isUserLoading)
            Center(
              child: EmptyPageWidget(
                icon: Icons.person_off_rounded,
                childBelow: Text(
                  'no_results'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: users.length + (msgPro.hasMoreUsers ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index >= users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final UserEntity user = users[index];
                final bool isSelected = user == _selectedUser;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedUser = isSelected ? null : user;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CustomNetworkImage(
                            fit: BoxFit.cover,
                            size: 50,
                            imageURL: user.profilePhotoURL,
                            placeholder: user.displayName,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.displayName,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.username,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedUser != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButton(
                isLoading: msgPro.isLoading,
                title: 'send'.tr(),
                onTap: () async {
                  final File file = await createUserVcf(_selectedUser!);
                  msgPro.addContact(
                    PickedAttachment(type: AttachmentType.contacts, file: file),
                  );
                  msgPro.sendContact(context);
                },
              ),
            ),
        ],
      ),
    );
  }
}
