import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../core/widgets/searchable_textfield.dart';
import '../../../create_chat/view/screens/create_group_bottomsheet.dart';
import '../../../create_chat/view/screens/create_private_chat_bottomsheet.dart';
import '../providers/chat_dashboard_provider.dart';

class ChatDashboardSearchableWidget extends StatelessWidget {
  const ChatDashboardSearchableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatDashboardProvider>(
        builder: (BuildContext context, ChatDashboardProvider pagePro, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: SearchableTextfield(
                controller: pagePro.searchController,
                onChanged: (String value) {
                  if (ChatPageType.orders == pagePro.currentPage) {
                    pagePro.updateSearchQuery(value);
                  } else if (ChatPageType.services == pagePro.currentPage) {
                    //skipping for the moment
                  } else if (ChatPageType.groups == pagePro.currentPage) {
                    pagePro.updateSearchQuery(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            pagePro.currentPage == ChatPageType.orders
                ? GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<CreatePrivateChatBottomsheet>(
                            builder: (BuildContext context) =>
                                CreatePrivateChatBottomsheet())),
                    child: Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorScheme.of(context).outlineVariant),
                            borderRadius: BorderRadius.circular(12)),
                        child: const CustomSvgIcon(
                            assetPath: AppStrings.selloutAddChatIcon)))
                : pagePro.currentPage == ChatPageType.services
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.card_membership_sharp),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<CreateGroupBottomSheet>(
                                builder: (BuildContext context) =>
                                    const CreateGroupBottomSheet())),
                        child: Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        ColorScheme.of(context).outlineVariant),
                                borderRadius: BorderRadius.circular(12)),
                            child: const CustomSvgIcon(
                                assetPath: AppStrings.selloutAddChatIcon)))
          ],
        ),
      );
    });
  }
}
