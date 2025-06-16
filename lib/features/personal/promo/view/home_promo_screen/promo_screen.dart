import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/video_widget.dart';
import '../../../../../services/get_it.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../domain/entities/promo_entity.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({
    required this.promo,
    super.key,
  });

  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    final GetPostByIdUsecase getPostByIdUsecase = GetPostByIdUsecase(locator());
    final GetUserByUidUsecase getUserByUid = GetUserByUidUsecase(locator());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: double.infinity,
        leading: FutureBuilder<DataState<UserEntity?>>(
          future: getUserByUid.call(promo.createdBy),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 40,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
              );
            }

            String profileUrl = 'https://via.placeholder.com/150';
            String username = 'Unknown';

            if (snapshot.hasData && snapshot.data is DataSuccess<UserEntity?>) {
              final UserEntity? user =
                  (snapshot.data as DataSuccess<UserEntity?>).entity;
              if (user != null) {
                profileUrl = user.profilePhotoURL ?? profileUrl;
                username = user.username;
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(profileUrl),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(_formatTimeAgo(promo.createdAt),
                            style: const TextStyle(
                                color: Colors.green, fontSize: 10)),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.favorite_border, size: 14),
                      const SizedBox(width: 2),
                      const Text('45', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 6),
                      const Icon(Icons.remove_red_eye, size: 14),
                      const SizedBox(width: 2),
                      Text(promo.views?.length.toString() ?? 'na'.tr(),
                          style: const TextStyle(fontSize: 10)),
                      const SizedBox(width: 6),
                      const Icon(Icons.more_vert, size: 16),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: isVideo(promo.fileUrl)
                ? VideoWidget(videoSource: promo.fileUrl)
                : Image.network(
                    promo.fileUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                Text(
                  '${promo.title} - \$${promo.price ?? "0"}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.tag),
                )
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                        final DataState<List<PostEntity>> dataState =
                            await getPostByIdUsecase.call(promo.referenceId);
                        Navigator.pop(context);
                        if (dataState is DataSuccess<List<PostEntity>> &&
                            dataState.entity != null &&
                            dataState.entity!.isNotEmpty) {
                          final PostEntity post = dataState.entity!.first;
                          Navigator.of(context).pushNamed(
                            PostDetailScreen.routeName,
                            arguments: <String, PostEntity>{'pid': post},
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('post_not_found'.tr())),
                          );
                        }
                      },
                      iconAlignment: IconAlignment.end,
                      label: Text(
                        'order_now_>'.tr(),
                      ),
                      icon: const Icon(Icons.shopping_cart_outlined)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(String timestamp) {
    final DateTime? date = DateTime.tryParse(timestamp);
    if (date == null) return '';
    final Duration duration = DateTime.now().difference(date);
    if (duration.inDays > 0) return '${duration.inDays} days ago';
    if (duration.inHours > 0) return '${duration.inHours} hours ago';
    if (duration.inMinutes > 0) return '${duration.inMinutes} minutes ago';
    return 'just now';
  }

  bool isVideo(String url) {
    final String lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.endsWith('.avi') ||
        lowerUrl.endsWith('.mkv') ||
        lowerUrl.endsWith('.webm');
  }
}
