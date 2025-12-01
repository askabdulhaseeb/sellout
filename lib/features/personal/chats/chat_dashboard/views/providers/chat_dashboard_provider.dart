import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../core/enums/chat/chat_page_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../data/sources/local/local_chat.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/usecase/get_my_chats_usecase.dart';
export '../../../../../../core/enums/chat/chat_page_type.dart';

class ChatDashboardProvider extends ChangeNotifier {
  ChatDashboardProvider(this._getMyChatsUsecase) {
    init();
  }

  final GetMyChatsUsecase _getMyChatsUsecase;

  late ValueListenable<Box<ChatEntity>> _chatBoxListener;

  List<ChatEntity> _filteredChats = <ChatEntity>[];
  List<ChatEntity> get filteredChats => _filteredChats;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  TextEditingController searchController = TextEditingController();

  final Map<String, BusinessEntity?> businessCache =
      <String, BusinessEntity?>{};
  final Map<String, UserEntity?> userCache = <String, UserEntity?>{};
  final Map<String, PostEntity?> postCache = <String, PostEntity?>{};

  ChatPageType _page = ChatPageType.orders;
  ChatPageType get currentPage => _page;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void init() {
    _chatBoxListener = LocalChat.boxLive.listenable()
      ..addListener(_onBoxChanged);
    _onBoxChanged();
  }

  void _onBoxChanged() {
    // Always use Hive as source of truth
    final List<ChatEntity> allChats = LocalChat.boxLive.values.toList();
    _applyTabAndSearch(allChats);
    _fetchMissingEntities(allChats);
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.toLowerCase();
    _applyTabAndSearch(LocalChat.boxLive.values.toList());
  }

  void setCurrentTabIndex(ChatPageType value) {
    _page = value;
    _applyTabAndSearch(LocalChat.boxLive.values.toList());
  }

  void _applyTabAndSearch(List<ChatEntity> allChats) {
    List<ChatEntity> filtered = allChats;

    // --- Filter chats based on current tab ---
    if (_page == ChatPageType.orders) {
      // Orders tab: show private and product chats
      filtered = filtered
          .where(
            (ChatEntity c) =>
                c.type == ChatType.private ||
                (c.type == ChatType.product &&
                    c.productInfo?.type != ChatType.service),
          )
          .toList();
    } else if (_page == ChatPageType.services) {
      filtered = filtered
          .where(
            (ChatEntity c) =>
                c.type == ChatType.product &&
                c.productInfo?.type == ChatType.service,
          )
          .toList();
    } else if (_page == ChatPageType.groups) {
      // Groups tab: only group chats
      filtered = filtered
          .where((ChatEntity c) => c.type == ChatType.group)
          .toList();
    }
    // --- Search filter ---
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((ChatEntity chat) {
        final String lastMsg =
            chat.lastMessage?.displayText.toLowerCase() ?? '';
        final String other = chat.otherPerson();

        if (chat.type == ChatType.private ||
            (chat.type == ChatType.product &&
                chat.productInfo?.type == ChatType.requestQuote)) {
          final String name = other.startsWith('BU')
              ? businessCache[other]?.displayName?.toLowerCase() ?? ''
              : userCache[other]?.displayName.toLowerCase() ?? '';

          return name.contains(_searchQuery) || lastMsg.contains(_searchQuery);
        } else if (chat.type == ChatType.group) {
          final String groupName = chat.groupInfo?.title.toLowerCase() ?? '';
          return groupName.contains(_searchQuery) ||
              lastMsg.contains(_searchQuery);
        }
        return false;
      }).toList();
    }

    // --- Sort by lastMessage date ---
    _filteredChats = filtered
      ..sort(
        (ChatEntity a, ChatEntity b) =>
            (b.lastMessage?.createdAt ?? DateTime(0)).compareTo(
              a.lastMessage?.createdAt ?? DateTime(0),
            ),
      );

    notifyListeners();
  }

  Future<void> _fetchMissingEntities(List<ChatEntity> allChats) async {
    for (final ChatEntity chat in allChats) {
      final String other = chat.otherPerson();

      if (chat.type == ChatType.private) {
        if (other.startsWith('BU') && businessCache[other] == null) {
          businessCache[other] = await LocalBusiness().getBusiness(other);
        } else if (!other.startsWith('BU') && userCache[other] == null) {
          userCache[other] = await LocalUser().user(other);
        }
      }

      if (chat.type == ChatType.product &&
          chat.productInfo?.id != null &&
          postCache[chat.productInfo!.id] == null) {
        postCache[chat.productInfo!.id] = await LocalPost().getPost(
          chat.productInfo!.id,
        );
      }
    }
    notifyListeners();
  }

  /// --- Fetch chats from backend ---
  Future<DataState<List<ChatEntity>>> getChats() async {
    setLoading(true);
    final DataState<List<ChatEntity>> result = await _getMyChatsUsecase.call(
      null,
    );

    if (result is DataSuccess) {
      // Save to Hive, Hive listener updates provider automatically
      final Box<ChatEntity> box = LocalChat.boxLive;
      for (final chat in result.entity ?? <dynamic>[]) {
        box.put(chat.chatId, chat);
      }
    } else {
      AppLog.error(result.exception?.message ?? 'something went wrong');
    }
    setLoading(false);
    return result;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatBoxListener.removeListener(_onBoxChanged);
    searchController.dispose();
    super.dispose();
  }
}
