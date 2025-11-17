import '../../../../../../../core/widgets/empty_page_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../domain/usecase/get_user_by_uid.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<SupporterDetailEntity> supporters =
        widget.supporters ?? <SupporterDetailEntity>[];

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
            child: supporters.isEmpty
                ? EmptyPageWidget(
                    icon: Icons.people_outline,
                    childBelow: Text('no_supporters_found'.tr()),
                  )
                : ListView.builder(
                    itemCount: supporters.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SupporterDetailEntity supporter = supporters[index];
                      if (supporter.userID.startsWith('BU')) {
                        return BusinessSupporterTile(
                          businessId: supporter.userID,
                          searchQuery: searchController.text,
                          alwaysShow: true,
                        );
                      } else {
                        return UserSupporterTile(
                          userId: supporter.userID,
                          searchQuery: searchController.text,
                          alwaysShow: true,
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
    this.alwaysShow = false,
    super.key,
  });

  final String businessId;
  final String searchQuery;
  final bool alwaysShow;

  @override
  State<BusinessSupporterTile> createState() => _BusinessSupporterTileState();
}

class _BusinessSupporterTileState extends State<BusinessSupporterTile> {
  final GetBusinessByIdUsecase getBusiness = GetBusinessByIdUsecase(locator());
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
    // If loading, show a placeholder tile
    if (isLoading) {
      return _buildPlaceholderTile(context, 'Loading...');
    }
    // If failed to load
    if (business == null) {
      return _buildPlaceholderTile(context, 'Business not found');
    }
    // Filter by search query
    if (!business!.displayName!
        .toLowerCase()
        .contains(widget.searchQuery.toLowerCase())) {
      return widget.alwaysShow
          ? _buildPlaceholderTile(context, 'No match')
          : const SizedBox();
    }

    return _buildBusinessTile(context);
  }

  Widget _buildPlaceholderTile(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
            color: ColorScheme.of(context).outline.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.business, color: Colors.white),
        ),
        title: Text(message, style: TextTheme.of(context).bodySmall),
        trailing: LocalAuth.uid != widget.businessId
            ? SizedBox(
                width: 100,
                child: SupportButton(supporterId: widget.businessId),
              )
            : null,
      ),
    );
  }

  Widget _buildBusinessTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
            color: ColorScheme.of(context).outline.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CustomNetworkImage(
            placeholder: business?.displayName ?? 'na'.tr(),
            imageURL: business?.logo?.url ?? '',
            size: 50,
            fit: BoxFit.cover,
            color: Colors.grey.shade300,
          ),
        ),
        title: Wrap(
          spacing: 4,
          children: <Widget>[
            Text(
              business?.displayName ?? 'na',
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).bodySmall,
            ),
            CircleAvatar(
              radius: 8,
              backgroundColor: Theme.of(context).primaryColor,
              child: const FittedBox(
                child: Text(
                  'B',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        trailing: LocalAuth.uid != business!.businessID
            ? SizedBox(
                width: 100,
                child: SupportButton(supporterId: business?.businessID ?? ''),
              )
            : null,
      ),
    );
  }
}

class UserSupporterTile extends StatefulWidget {
  const UserSupporterTile({
    required this.userId,
    required this.searchQuery,
    this.alwaysShow = false,
    super.key,
  });

  final String userId;
  final String searchQuery;
  final bool alwaysShow;

  @override
  State<UserSupporterTile> createState() => _UserSupporterTileState();
}

class _UserSupporterTileState extends State<UserSupporterTile> {
  final GetUserByUidUsecase getUser = GetUserByUidUsecase(locator());
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
    // If loading, show a placeholder tile
    if (isLoading) {
      return _buildPlaceholderTile(context, 'Loading...');
    }
    // If failed to load
    if (user == null) {
      return _buildPlaceholderTile(context, 'User not found');
    }
    // Filter by search query
    if (!user!.username
        .toLowerCase()
        .contains(widget.searchQuery.toLowerCase())) {
      return widget.alwaysShow
          ? _buildPlaceholderTile(context, 'No match')
          : const SizedBox();
    }

    return _buildUserTile(context);
  }

  Widget _buildPlaceholderTile(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
            color: ColorScheme.of(context).outline.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(message, style: TextTheme.of(context).bodySmall),
        trailing: LocalAuth.uid != widget.userId
            ? SizedBox(
                width: 100,
                child: SupportButton(supporterId: widget.userId),
              )
            : null,
      ),
    );
  }

  Widget _buildUserTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
            color: ColorScheme.of(context).outline.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CustomNetworkImage(
            placeholder: user!.displayName,
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
      ),
    );
  }
}
