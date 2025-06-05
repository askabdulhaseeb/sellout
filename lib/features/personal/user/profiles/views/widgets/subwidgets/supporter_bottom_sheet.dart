import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/get_user_by_uid.dart';
import 'support_button.dart';
class SupporterBottomsheet extends StatefulWidget {
  const SupporterBottomsheet({
    required this.supporters,
    required this.issupporter,
    super.key,
  });

  final List<SupporterDetailEntity>? supporters;
  final bool issupporter;

  @override
  State<SupporterBottomsheet> createState() => _SupporterBottomsheetState();
}

class _SupporterBottomsheetState extends State<SupporterBottomsheet> {
  final TextEditingController searchController = TextEditingController();
  final GetUserByUidUsecase getUserByUidUsecase = GetUserByUidUsecase(locator());

  List<UserEntity> allUsers = [];
  List<UserEntity> filteredUsers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _fetchAllUsers() async {
    final supporters = widget.supporters ?? [];

    final List<UserEntity> temp = [];

    for (final supporter in supporters) {
      if (supporter.userID.isEmpty) continue;
      final result = await getUserByUidUsecase(supporter.userID);
      if (result.entity != null) {
        temp.add(result.entity!);
      }
    }

    setState(() {
      allUsers = temp;
      filteredUsers = temp;
      isLoading = false;
    });
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredUsers = allUsers.where((user) {
        return user.username.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: MediaQuery.of(context).size.height * 0.66,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              label: Text('close'.tr(), style: textTheme.labelSmall),
              icon: Icon(Icons.close, size: 16, color: ColorScheme.of(context).onSurface),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          CustomTextFormField(
            hint: 'search'.tr(),
            prefixIcon: const Icon(Icons.search),
            controller: searchController,
          ),
          const SizedBox(height: 8, width: double.infinity),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CustomNetworkImage(
                              imageURL: user.profilePhotoURL ?? '',
                              fit: BoxFit.cover,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        title: Text(
                          user.username,
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: LocalAuth.uid != user.uid
                            ? SizedBox(
                                width: 100,
                                child: SupportButton(supporterId: user.uid),
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
