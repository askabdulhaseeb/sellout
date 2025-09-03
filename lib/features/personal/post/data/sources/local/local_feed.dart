// import 'package:hive/hive.dart';
// import '../../../../../../core/utilities/app_string.dart';
// import '../../../domain/entities/feed/feed_entity.dart';
//

// class LocalFeed {
//   static String boxTitle = AppStrings.localPostListCache;
//   static Box<FeedEntity> get box => Hive.box<FeedEntity>(boxTitle);

//   static Future<Box<FeedEntity>> openBox() async {
//     return Hive.isBoxOpen(boxTitle)
//         ? box
//         : await Hive.openBox<FeedEntity>(boxTitle);
//   }

//   Future<Box<FeedEntity>> refresh() async {
//     final bool isOpen = Hive.isBoxOpen(boxTitle);
//     if (isOpen) {
//       return box;
//     } else {
//       return await Hive.openBox<FeedEntity>(boxTitle);
//     }
//   }

//   Future<void> clear() async {
//     if (!Hive.isBoxOpen(boxTitle)) {
//       await Hive.openBox<FeedEntity>(boxTitle);
//     }
//     await box.clear();
//   }

//   static Future<void> save(FeedEntity entity) async {
//     await box.put(entity.endpointHash, entity);
//   }

//   static FeedEntity? get(String endpointHash) {
//     return box.get(endpointHash);
//   }

//   static Future<void> delete(String endpointHash) async {
//     await box.delete(endpointHash);
//   }

//   static List<PostEntity> getPostsForEndpoint(String endpointHash) {
//     final FeedEntity? entity = get(endpointHash);
//     return entity?.posts ?? [];
//   }

//   static String? getNextPageToken(String endpointHash) {
//     final FeedEntity? entity = get(endpointHash);
//     return entity?.nextPageToken;
//   }
// }
