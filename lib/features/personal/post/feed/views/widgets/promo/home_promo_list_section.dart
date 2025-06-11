import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_shimmer_effect.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/view/provider/promo_provider.dart';
import '../../../../../promo/view/screens/create_promo_screen.dart';

class HomePromoListSection extends StatefulWidget {
  const HomePromoListSection({super.key});

  @override
  State<HomePromoListSection> createState() => _HomePromoListSectionState();
}

class _HomePromoListSectionState extends State<HomePromoListSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PromoProvider>(context, listen: false).getPromoOfFollower();
    });
  }

  @override
@override
Widget build(BuildContext context) {
  final List<PromoEntity>? pro = Provider.of<PromoProvider>(context).promoList;

  final bool isLoading = pro == null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'promo'.tr(),
              style: TextTheme.of(context).titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InDevMode(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'view_more'.tr(),
                  style: TextTheme.of(context).bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.primaryColor,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),

      SizedBox(
        height: 130,
        child: isLoading
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const _PromoShimmerCard();
                },
              )
            : (pro.isEmpty
                ? Center(
                    child: Text('No promos found', style: TextTheme.of(context).bodySmall),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: pro.length + 1, // +1 for AddPromoCard
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return const AddPromoCard();
                      final PromoEntity promo = pro[index - 1];
                      return PromoItemCard(title: promo.title, file: promo.fileUrl);
                    },
                  )),
      ),
    ],
  );
}
}

class AddPromoCard extends StatelessWidget {
  const AddPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CreatePromoScreen.routeName);
      },
      child: SizedBox(              width: 80,

        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned.fill(
                    top: 0,
                    bottom: 30,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: Text(
                      'promo'.tr(),
                      style: TextTheme.of(context).bodyLarge?.copyWith(
                            color: ColorScheme.of(context).onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor,
                        border: Border.all(color: ColorScheme.of(context).onPrimary),
                      ),
                      child: Icon(Icons.add, size: 20, color: ColorScheme.of(context).onPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Text('create_yours'.tr(), style: TextTheme.of(context).bodySmall,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }
}
class PromoItemCard extends StatelessWidget {
  const PromoItemCard({
    required this.title,
    required this.file,
    super.key,
  });

  final String title;
  final String file;

  bool isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
           lower.endsWith('.mov') ||
           lower.endsWith('.webm') ||
           lower.endsWith('.avi');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    file,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 100,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                  if (isVideo(file))
                     Positioned.fill(
                      child: VideoWidget(videoSource: file,play: false,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextTheme.of(context).bodySmall,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class _PromoShimmerCard extends StatelessWidget {
  const _PromoShimmerCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  CustomShimmer(
                    child: Container(
                      width: 80,
                      height: 100,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          CustomShimmer(
            child: Container(
              width: 60,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
