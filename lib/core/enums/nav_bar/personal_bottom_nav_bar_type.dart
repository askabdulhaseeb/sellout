import '../../utilities/app_string.dart';

enum PersonalBottomNavBarType {
  home('home', 0, AppStrings.selloutBottombarHomeOutlineIcon,
      AppStrings.selloutBottombarHomeFilledIcon),
  explore('explore', 1, AppStrings.selloutBottombarMarketplaceOutlineIcon,
      AppStrings.selloutBottombarMarketplaceFilledIcon),
  services('services', 2, AppStrings.selloutBottombarServicesOutlineIcon,
      AppStrings.selloutBottombarServicesFilledIcon),
  add('add', 3, AppStrings.selloutBottombarListingOutlineIcon,
      AppStrings.selloutBottombarListingFilledIcon),
  chats('chats', 4, AppStrings.selloutBottombarChatsOutlineIcon,
      AppStrings.selloutBottombarChatsFilledIcon),
  profile('profile', 5, AppStrings.selloutBottombarProfileOutlineIcon,
      AppStrings.selloutBottombarProfileFilledIcon);

  const PersonalBottomNavBarType(
    this.code,
    this.number,
    this.icon,
    this.activeIcon,
  );
  final String code;
  final int number;
  final String icon;
  final String activeIcon;

  static List<PersonalBottomNavBarType> get list => <PersonalBottomNavBarType>[
        home,
        explore,
        services,
        add,
        chats,
        profile,
      ];
}
