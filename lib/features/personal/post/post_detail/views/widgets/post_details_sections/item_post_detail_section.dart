import 'package:flutter/material.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../post_detail_description_section.dart';
import '../post_detail_postage_return_delivery.dart';
import '../post_detail_seller_section.dart';
import '../reviews/post_detail_review_overview_section.dart';

class ItemPostDetailSection extends StatelessWidget {
  const ItemPostDetailSection({
    required this.post,
    super.key,
  });
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        // ConditionDeliveryWidget(post: post),
        PostDetailDescriptionSection(post: post),
        ReturnPosrtageAndExtraDetailsSection(post: post),
        PostDetailSellerSection(post: post),
        PostDetailReviewOverviewSection(post: post),
      ]),
    );
  }
}

  // import 'package:flutter/material.dart';
  // import 'package:socket_io_client/socket_io_client.dart' as IO;
  // class ChatScreen extends StatefulWidget {
  //   @override
  //   _ChatScreenState createState() => _ChatScreenState();
  // }
  // class _ChatScreenState extends State<ChatScreen> {
  //   late IO.Socket socket;
  //   List<String> onlineUsers = <String>[];
  //   String userId = "your-user-id";
  //   @override
  //   void initState() {
  //     super.initState();
  //     connectSocket();
  //   }
  //   void connectSocket() {
  //     socket = IO.io('http://localhost:3200', <String, dynamic>{
  //       'transports': <String>['websocket'],
  //       'autoConnect': true,
  //       'query': <String, String>{'entity_id': userId}
  //     });
  //     socket.on('connect', (_) {
  //       print('Connected to socket');
  //     });
  //     // OLD WAY: Only listening to getOnlineUsers
  //     socket.on('getOnlineUsers', (data) {
  //       print('Online users: $data');
  //       setState(() {
  //         onlineUsers = List<String>.from(data);
  //       });
  //     });
  //     socket.connect();
  //   }
  //   @override
  //   void dispose() {
  //     socket.disconnect();
  //     socket.dispose();
  //     super.dispose();
  //   }
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(title: Text('Online Users (${onlineUsers.length})')),
  //       body: ListView.builder(
  //         itemCount: onlineUsers.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return ListTile(
  //             title: Text(onlineUsers[index]),
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }

  // import 'package:flutter/material.dart';
  // import 'package:socket_io_client/socket_io_client.dart' as IO;
  // class ChatScreen extends StatefulWidget {
  //   @override
  //   _ChatScreenState createState() => _ChatScreenState();
  // }
  // class _ChatScreenState extends State<ChatScreen> {
  //   late IO.Socket socket;
  //   List<String> onlineUsers = <String>[];
  //   Map<String, String> lastSeenMap = <String, String>{}; // NEW: Track last seen times
  //   String userId = "your-user-id"; // Get from auth
  //   @override
  //   void initState() {
  //     super.initState();
  //     connectSocket();
  //   }
  //   void connectSocket() {
  //     socket = IO.io('http://localhost:3200', <String, dynamic>{
  //       'transports': <String>['websocket'],
  //       'autoConnect': true,
  //       'query': <String, String>{'entity_id': userId}
  //     });
  //     socket.on('connect', (_) {
  //       print('Connected to socket');
  //     });
  //     // :one: Initial full list when YOU connect
  //     socket.on('getOnlineUsers', (data) {
  //       print('Initial online users: $data');
  //       setState(() {
  //         onlineUsers = List<String>.from(data);
  //       });
  //     });
  //     // :two: NEW: When someone else comes online
  //     socket.on('userOnline', (entityId) {
  //       print('User came online: $entityId');
  //       setState(() {
  //         // Avoid duplicates
  //         if (!onlineUsers.contains(entityId)) {
  //           onlineUsers.add(entityId);
  //         }
  //         // Remove from last seen map
  //         lastSeenMap.remove(entityId);
  //       });
  //     });
  //     // :three: NEW: When someone goes offline
  //     socket.on('userOffline', (data) {
  //       final String entityId = data['entityId'];
  //       final String lastSeen = data['lastSeen'];
  //       print('User went offline: $entityId at $lastSeen');
  //       setState(() {
  //         onlineUsers.remove(entityId);
  //         lastSeenMap[entityId] = lastSeen;
  //       });
  //     });
  //     socket.connect();
  //   }
  //   // Helper function to format last seen
  //   String getLastSeenText(String lastSeenIso) {
  //     final DateTime lastSeen = DateTime.parse(lastSeenIso);
  //     final DateTime now = DateTime.now();
  //     final Duration difference = now.difference(lastSeen);
  //     if (difference.inMinutes < 1) return "Just now";
  //     if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
  //     if (difference.inHours < 24) return "${difference.inHours}h ago";
  //     return "${lastSeen.day}/${lastSeen.month}/${lastSeen.year}";
  //   }
  //   @override
  //   void dispose() {
  //     socket.disconnect();
  //     socket.dispose();
  //     super.dispose();
  //   }
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Chat'),
  //       ),
  //       body: Column(
  //         children: <Widget>[
  //           // Online Users Section
  //           ExpansionTile(
  //             title: Text('Online Users (${onlineUsers.length})'),
  //             initiallyExpanded: true,
  //             children: onlineUsers.map((String userId) {
  //               return ListTile(
  //                 leading: CircleAvatar(
  //                   backgroundColor: Colors.green,
  //                   radius: 6,
  //                 ),
  //                 title: Text(userId),
  //                 subtitle: Text('Online'),
  //               );
  //             }).toList(),
  //           ),
  //           // Recently Offline Users Section (Optional)
  //           if (lastSeenMap.isNotEmpty)
  //             ExpansionTile(
  //               title: Text('Recently Offline (${lastSeenMap.length})'),
  //               children: lastSeenMap.entries.map((MapEntry<String, String> entry) {
  //                 return ListTile(
  //                   leading: const CircleAvatar(
  //                     backgroundColor: Colors.grey,
  //                     radius: 6,
  //                   ),
  //                   title: Text(entry.key),
  //                   subtitle: Text('Last seen: ${getLastSeenText(entry.value)}'),
  //                 );
  //               }).toList(),
  //             ),
  //         ],
  //       ),
  //     );
  //   }
  // }
