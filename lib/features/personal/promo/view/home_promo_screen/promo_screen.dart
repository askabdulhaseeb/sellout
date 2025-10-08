import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../core/widgets/video_widget.dart';
import '../../../../../services/get_it.dart';
import '../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../user/profiles/domain/entities/user_entity.dart'
    show UserEntity;
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../domain/entities/promo_entity.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({required this.promo, super.key});
  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PromoAppBar(promo: promo),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(child: PromoMedia(promo: promo)),
          if (promo.referenceId != '')
            PromoFooter(
              promo: promo,
              onOrderNow: () {
                if (promo.referenceId.isNotEmpty) {
                  Navigator.of(context).pushNamed(
                    PostDetailScreen.routeName,
                    arguments: <String, String>{'pid': promo.referenceId},
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('post_not_found')),
                  );
                }
              },
            ),
          const SizedBox(
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

class PromoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PromoAppBar({required this.promo, super.key});
  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUid = GetUserByUidUsecase(locator());

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: double.infinity,
      leading: FutureBuilder<DataState<UserEntity?>>(
        future: getUserByUid.call(promo.createdBy),
        builder: (BuildContext context,
            AsyncSnapshot<DataState<UserEntity?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 1.5));
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios)),
                CircleAvatar(
                    radius: 18, backgroundImage: NetworkImage(profileUrl)),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                InDevMode(
                  child: Row(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // String _formatTimeAgo(String timestamp) {
  //   final DateTime? date = DateTime.tryParse(timestamp);

  //   if (date == null) {
  //     debugPrint('Invalid timestamp: $timestamp');
  //     return '';
  //   }

  //   final Duration duration = DateTime.now().difference(date);
  //   if (duration.inDays > 0) {
  //     return '${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'} ago';
  //   }
  //   if (duration.inHours > 0) {
  //     return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} ago';
  //   }
  //   if (duration.inMinutes > 0) {
  //     return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  //   }
  //   return 'just now';
  // }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PromoMedia extends StatelessWidget {
  const PromoMedia({required this.promo, super.key});
  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    if ((promo.promoType).toLowerCase() == 'image') {
      return CachedNetworkImage(
        imageUrl: promo.fileUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
        errorWidget: (_, __, ___) => const Center(
          child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
        ),
      );
    } else {
      return Expanded(
        child: VideoWidget(
          showTime: true,
          play: true,
          videoSource: promo.fileUrl,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}

class PromoFooter extends StatelessWidget {
  const PromoFooter({
    required this.promo,
    required this.onOrderNow,
    super.key,
  });

  final PromoEntity promo;
  final VoidCallback onOrderNow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Expanded(
                  child: Text(
                    '${promo.title} - \$${promo.price ?? "0"}',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: theme.primaryColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: theme.primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onOrderNow,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(
                    'order_now_>'.tr(),
                    style: TextTheme.of(context)
                        .titleSmall
                        ?.copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.shopping_cart_outlined,
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        )
      ],
    );
  }
}
