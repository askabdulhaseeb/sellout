import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../../features/business/core/data/sources/local_business.dart';
import '../../../../features/business/core/domain/entity/business_entity.dart';
import '../../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../features/personal/basket/data/models/cart/cart_item_model.dart';
import '../../../../features/personal/basket/data/sources/local/local_cart.dart';
import '../../../../features/personal/basket/views/screens/personal_shopping_basket_screen.dart';
import '../../../../features/personal/notifications/view/screens/notification_screen.dart';
import '../../../../features/personal/search/view/view/search_screen.dart';
import '../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../../features/personal/user/profiles/domain/entities/business_profile_detail_entity.dart';
import '../../../../routes/app_linking.dart';
import '../../../utilities/app_string.dart';
import '../../custom_svg_icon.dart';
import '../../profile_photo.dart';

personalAppbar(BuildContext context) {
  final String me = LocalAuth.uid ?? '';
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shadowColor: Theme.of(context).colorScheme.outlineVariant,
    title: Row(
      children: <Widget>[
        if (LocalAuth.currentUser != null)
          FutureBuilder<UserEntity?>(
            future: LocalUser().user(me),
            initialData: LocalUser().userEntity(me),
            builder:
                (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
                  final UserEntity? user = snapshot.data;
                  return user == null
                      ? const SizedBox()
                      : _IconButton(
                          icon: AppStrings.selloutMyUsersListIcon,
                          onPressed: () async =>
                              await showProfileMenu(context, user),
                        );
                  // Container(
                  //   width: 62,
                  //   margin: const EdgeInsets.only(right: 8),
                  //   padding: const EdgeInsets.symmetric(
                  //     vertical: 7,
                  //     horizontal: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Theme.of(context).dividerColor,
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: () async => await showProfileMenu(context, user),
                  //     onLongPress: () async =>
                  //         await showProfileMenu(context, user),
                  //     onDoubleTap: () async =>
                  //         await showProfileMenu(context, user),
                  //     child: Row(
                  //       children: <Widget>[
                  //         const SizedBox(width: 4),
                  //         CircleAvatar(
                  //           radius: 12,
                  //           backgroundColor: Theme.of(context).primaryColor,
                  //           child: ProfilePhoto(
                  //             url: user.profilePhotoURL,
                  //             isCircle: true,
                  //             size: 10,
                  //           ),
                  //         ),
                  //         const Icon(Icons.keyboard_arrow_down_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
          ),
        _IconButton(
          icon: AppStrings.selloutSearchIcon,
          onPressed: () {
            AppNavigator.pushNamed(SearchScreen.routeName);
          },
        ),
      ],
    ),
    actions: <Widget>[
      _IconButton(
        icon: AppStrings.selloutNotificationBellIcon,
        onPressed: () {
          AppNavigator.pushNamed(NotificationsScreen.routeName);
        },
      ),
      if (me.isNotEmpty)
        ValueListenableBuilder<Box<CartEntity>>(
          valueListenable: LocalCart().listenable(),
          builder: (BuildContext context, Box<CartEntity> cartBox, __) {
            final CartEntity cart = cartBox.values.firstWhere(
              (CartEntity element) => element.cartID == me,
              orElse: () => CartModel(),
            );
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _IconButton(
                  icon: AppStrings.selloutShoppingCartIcon,
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamed(PersonalShoppingBasketScreen.routeName),
                ),
                if (cart.cartItemsCount > 0)
                  Positioned(
                    right: 0,
                    top: -8,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          cart.cartItemsCount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      const SizedBox(width: 8),
    ],
  );
}

Future<void> showProfileMenu(BuildContext context, UserEntity user) async {
  final String me = LocalAuth.uid ?? '';
  final List<ProfileBusinessDetailEntity> ids = <ProfileBusinessDetailEntity>[
    ProfileBusinessDetailEntity(
      businessID: me,
      roleSTR: 'personal',
      statusSTR: 'active',
      addedAt: DateTime.now(),
    ),
    ...user.businessDetail,
  ];
  //
  showMenu(
    context: context,
    position: RelativeRect.fill,
    items: ids
        .map(
          (ProfileBusinessDetailEntity e) =>
              PopupMenuItem<ProfileBusinessDetailEntity>(
                value: e,
                child: e.businessID == me
                    ? ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        visualDensity: const VisualDensity(
                          vertical: -4,
                          horizontal: -4,
                        ),
                        leading: ProfilePhoto(
                          url: user.profilePhotoURL,
                          isCircle: true,
                          size: 18,
                        ),
                        title: Text(user.displayName),
                      )
                    : FutureBuilder<BusinessEntity?>(
                        future: LocalBusiness().getBusiness(e.businessID),
                        initialData: LocalBusiness().business(e.businessID),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<BusinessEntity?> snapshot,
                            ) {
                              final BusinessEntity? business = snapshot.data;
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                visualDensity: const VisualDensity(
                                  vertical: -4,
                                  horizontal: -4,
                                ),
                                leading: ProfilePhoto(
                                  url: business?.logo?.url,
                                  isCircle: true,
                                  size: 18,
                                ),
                                title: Text(business?.displayName ?? ''),
                                subtitle: Text(e.roleSTR),
                              );
                            },
                      ),
              ),
        )
        .toList(),
  );
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onPressed});
  final String icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomSvgIcon(assetPath: icon, size: 18),
        ),
      ),
    );
  }
}
