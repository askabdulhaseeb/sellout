import '../../utilities/app_string.dart';

enum ChatPageType {
  orders('chats', AppStrings.selloutOrderChatIcon),
  services('services', AppStrings.selloutServiceChatIcon),
  groups('groups', AppStrings.selloutGroupChatIcon);

  const ChatPageType(this.code, this.icon);
  final String code;
  final String icon;

  static ChatPageType fromJson(String json) => ChatPageType.values.firstWhere(
        (ChatPageType e) => e.code == json,
        orElse: () => ChatPageType.orders,
      );
}
