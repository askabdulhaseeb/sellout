import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../domain/usecase/get_user_by_uid.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../subwidgets/support_button.dart';

class SupporterBottomsheet extends StatefulWidget {
  const SupporterBottomsheet({
    required this.supporters,
    super.key,
  });

  final List<SupporterDetailEntity>? supporters;

  @override
  State<SupporterBottomsheet> createState() => _SupporterBottomsheetState();
}

class _SupporterBottomsheetState extends State<SupporterBottomsheet> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final supporters = widget.supporters ?? <SupporterDetailEntity>[];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: MediaQuery.of(context).size.height * 0.66,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              label: Text('close'.tr(), style: textTheme.labelSmall),
              icon: Icon(Icons.close,
                  size: 16, color: ColorScheme.of(context).onSurface),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          CustomTextFormField(
            hint: 'search'.tr(),
            prefixIcon: const Icon(Icons.search),
            controller: searchController,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: supporters.length,
              itemBuilder: (context, index) {
                final supporter = supporters[index];
                if (supporter.userID.startsWith('BU')) {
                  return BusinessSupporterTile(
                    businessId: supporter.userID,
                    searchQuery: searchController.text,
                  );
                } else {
                  return UserSupporterTile(
                    userId: supporter.userID,
                    searchQuery: searchController.text,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class BusinessSupporterTile extends StatefulWidget {
  const BusinessSupporterTile({
    required this.businessId,
    required this.searchQuery,
    super.key,
  });

  final String businessId;
  final String searchQuery;

  @override
  State<BusinessSupporterTile> createState() => _BusinessSupporterTileState();
}

class _BusinessSupporterTileState extends State<BusinessSupporterTile> {
  final getBusiness = GetBusinessByIdUsecase(locator());
  BusinessEntity? business;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusiness();
  }

  void _fetchBusiness() async {
    final DataState<BusinessEntity?> result =
        await getBusiness(widget.businessId);
    if (mounted) {
      setState(() {
        business = result.entity;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || business == null) return const SizedBox();
    if (!business!.displayName!
        .toLowerCase()
        .contains(widget.searchQuery.toLowerCase())) {
      return const SizedBox(); // filtered out
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CustomNetworkImage(
          imageURL: business?.logo?.url ?? '',
          size: 50,
          fit: BoxFit.cover,
          color: Colors.grey.shade300,
        ),
      ),
      title: Text(
        business?.displayName ?? 'na',
        overflow: TextOverflow.ellipsis,
        style: TextTheme.of(context).bodySmall,
      ),
      trailing: LocalAuth.uid != business!.businessID
          ? SizedBox(
              width: 100,
              child: SupportButton(supporterId: business?.businessID ?? ''),
            )
          : null,
    );
  }
}

class UserSupporterTile extends StatefulWidget {
  const UserSupporterTile({
    required this.userId,
    required this.searchQuery,
    super.key,
  });

  final String userId;
  final String searchQuery;

  @override
  State<UserSupporterTile> createState() => _UserSupporterTileState();
}

class _UserSupporterTileState extends State<UserSupporterTile> {
  final getUser = GetUserByUidUsecase(locator());
  UserEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    final DataState<UserEntity?> result = await getUser(widget.userId);
    if (mounted) {
      setState(() {
        user = result.entity;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || user == null) return const SizedBox();

    if (!user!.username
        .toLowerCase()
        .contains(widget.searchQuery.toLowerCase())) {
      return const SizedBox(); // filtered out
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CustomNetworkImage(
          imageURL: user!.profilePhotoURL ?? '',
          size: 50,
          fit: BoxFit.cover,
          color: Colors.grey.shade300,
        ),
      ),
      title: Text(
        user!.username,
        overflow: TextOverflow.ellipsis,
        style: TextTheme.of(context).bodySmall,
      ),
      trailing: LocalAuth.uid != user!.uid
          ? SizedBox(
              width: 100,
              child: SupportButton(supporterId: user!.uid),
            )
          : null,
    );
  }
}
