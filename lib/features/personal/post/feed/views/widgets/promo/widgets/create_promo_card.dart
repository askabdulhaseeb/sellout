import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../routes/app_linking.dart';
import '../../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../../promo/view/create_promo/screens/create_promo_screen.dart';
import '../../../../../../promo/view/home_promo_screen/promo_feed_screen.dart';

class AddPromoCard extends StatelessWidget {
  const AddPromoCard({super.key, this.myPromos, this.isLoading = false});

  final List<PromoEntity>? myPromos;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasPromos = myPromos != null && myPromos!.isNotEmpty;

    void openMyPromoOrCreate() {
      if (isLoading) return;

      if (hasPromos) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          elevation: 0,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (_) => PromoFeedScreen(promos: myPromos!, initialIndex: 0),
        );
      } else {
        AppNavigator.pushNamed(CreatePromoScreen.routeName);
      }
    }

    void openCreatePromo() {
      if (isLoading) return;
      AppNavigator.pushNamed(CreatePromoScreen.routeName);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 80,
          height: 90,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasPromos ? theme.primaryColor : theme.dividerColor,
              width: hasPromos ? 2.5 : 2,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Material(
              type: MaterialType.transparency,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (hasPromos)
                    Positioned.fill(
                      child: _buildHasPromosLayout(
                        context,
                        count: myPromos!.length,
                      ),
                    ),

                  // Upper banner
                  if (!hasPromos)
                    Positioned.fill(
                      top: 0,
                      bottom: 25,
                      child: _buildTopPreview(context, hasPromos),
                    ),

                  // White space preview (bottom strip)
                  if (!hasPromos)
                    Positioned.fill(
                      top: 65,
                      child: _buildBottomPreview(context, hasPromos),
                    ),

                  // Divider between sections
                  if (!hasPromos)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 65,
                      child: Container(
                        height: 1,
                        color: theme.dividerColor.withValues(alpha: 0.6),
                      ),
                    ),

                  if (!hasPromos)
                    Positioned(
                      bottom: 45,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        'promo'.tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                  if (hasPromos)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.scaffoldBackgroundColor,
                          border: Border.all(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.add_circle,
                          size: 18,
                          color: theme.primaryColor,
                        ),
                      ),
                    )
                  else
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor,
                          border: Border.all(color: colorScheme.onPrimary),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),

                  // Tap zones with ink feedback
                  Positioned.fill(
                    bottom: 25,
                    child: InkWell(
                      onTap: openMyPromoOrCreate,
                      splashColor: colorScheme.onPrimary.withValues(
                        alpha: 0.12,
                      ),
                      highlightColor: colorScheme.onPrimary.withValues(
                        alpha: 0.06,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 65,
                    child: InkWell(
                      onTap: openCreatePromo,
                      splashColor: theme.primaryColor.withValues(alpha: 0.12),
                      highlightColor: theme.primaryColor.withValues(
                        alpha: 0.06,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            'create_yours'.tr(),
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHasPromosLayout(BuildContext context, {required int count}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final PromoEntity latestPromo = myPromos!.first;
    final bool isImage = latestPromo.promoType.toLowerCase() == 'image';
    final String displayUrl = isImage
        ? latestPromo.fileUrl
        : (latestPromo.thumbnailUrl ?? '');

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: displayUrl.isEmpty
              ? Container(color: theme.primaryColor)
              : CachedNetworkImage(
                  imageUrl: displayUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: theme.primaryColor),
                  errorWidget: (_, _, _) =>
                      Container(color: theme.primaryColor),
                ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.15)),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.18),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$count',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'my_promo'.tr().toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopPreview(BuildContext context, bool hasPromos) {
    final ThemeData theme = Theme.of(context);

    Widget base = Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.sm),
        ),
      ),
    );

    if (isLoading) {
      base = Container(
        color: theme.primaryColor,
        child: const Center(
          child: SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    } else if (hasPromos) {
      final PromoEntity latestPromo = myPromos!.first;
      final bool isImage = latestPromo.promoType.toLowerCase() == 'image';
      final String displayUrl = isImage
          ? latestPromo.fileUrl
          : (latestPromo.thumbnailUrl ?? '');

      if (displayUrl.isNotEmpty) {
        base = CachedNetworkImage(
          imageUrl: displayUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (_, __) => Container(color: theme.primaryColor),
          errorWidget: (_, __, ___) => Container(color: theme.primaryColor),
        );
      } else {
        base = Container(color: theme.primaryColor);
      }
    } else {
      base = Container(color: theme.primaryColor);
    }

    // Light overlay to keep text readable while still showing the image.
    return Stack(
      children: <Widget>[
        Positioned.fill(child: base),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.35),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.sm),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPreview(BuildContext context, bool hasPromos) {
    final ThemeData theme = Theme.of(context);

    if (isLoading) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child: const Center(
          child: SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!hasPromos) {
      return Container(color: theme.scaffoldBackgroundColor);
    }

    final PromoEntity firstPromo = myPromos!.length > 1
        ? myPromos![1]
        : myPromos!.first;
    final bool isImage = firstPromo.promoType.toLowerCase() == 'image';
    final String displayUrl = isImage
        ? firstPromo.fileUrl
        : (firstPromo.thumbnailUrl ?? '');

    if (displayUrl.isEmpty) {
      return Container(color: theme.scaffoldBackgroundColor);
    }

    return CachedNetworkImage(
      imageUrl: displayUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => Container(color: theme.scaffoldBackgroundColor),
      errorWidget: (_, _, _) => Container(color: theme.scaffoldBackgroundColor),
    );
  }
}
