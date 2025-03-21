import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../services/get_it.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/get_user_by_uid.dart';

class SupporterBottomsheet extends StatelessWidget {
  const SupporterBottomsheet({
    required this.supporters,
    required this.issupporter,
    super.key,
  });

  final List<SupporterDetailEntity>? supporters;
  final bool issupporter;
  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextEditingController searchController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          /// Close Button
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              label: Text(
                'close'.tr(),
                style: const TextStyle(color: Colors.black),
              ),
              icon: const Icon(
                Icons.close,
                size: 16,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// Search Field
          CustomTextFormField(
            hint: 'search'.tr(),
            prefixIcon: const Icon(Icons.search),
            controller: searchController,
          ),
          const SizedBox(height: 8, width: double.infinity),

          /// Supporter List
          Expanded(
            child: ListView.builder(
              itemCount: supporters?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final SupporterDetailEntity? supporter = supporters?[index];

                if (supporter == null || supporter.userID.isEmpty) {
                  debugPrint('Skipping supporter: ${supporter?.userID}');
                  return const SizedBox.shrink();
                }

                debugPrint('Fetching user data for ID: ${supporter.userID}');

                return FutureBuilder<DataState<UserEntity?>>(
                  future: getUserByUidUsecase(supporter.userID),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataState<UserEntity?>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      debugPrint('Error loading user: ${snapshot.error}');
                      return const ListTile(
                        title: Text('Error loading user'),
                      );
                    }
                    if (snapshot.data == null || snapshot.data!.data == null) {
                      debugPrint(
                          'User data is null for ID: ${supporter.userID}');
                      return const ListTile(
                        title: Text('Error loading user'),
                      );
                    }

                    final UserEntity user = snapshot.data!.entity!;

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
                      trailing: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).primaryColor.withAlpha(20),
                        ),
                        child: Center(
                          child: Text(
                            issupporter == true
                                ? 'supporter'.tr()
                                : 'supporting'.tr(),
                            style: textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
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
    );
  }
}
