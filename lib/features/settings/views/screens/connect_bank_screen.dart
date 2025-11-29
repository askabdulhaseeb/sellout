import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utilities/app_string.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_svg_icon.dart';
import '../../../../core/constants/app_spacings.dart';
import '../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../bottomsheets/connect_bank_bottomsheet.dart';

class ConnectBankScreen extends StatelessWidget {
  const ConnectBankScreen({super.key});
  static const String routeName = '/connect-bank';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleKey: 'connect_bank_account'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomPaint(
                    size: const Size(double.infinity, 220),
                    painter:
                        _BubblePainter(primary: primary, onPrimary: onPrimary),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xl,
                      ),
                      child: Column(
                        children: <Widget>[
                          // 🏦 Bank Icon
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            width: 80,
                            height: 80,
                            child: CustomSvgIcon(
                              assetPath: AppStrings.selloutProfileBankIcon,
                              color: onPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // 📝 Title
                          Text(
                            'payouts_made_easy'.tr(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // 💬 Description
                          Text(
                            'connect_bank_description'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: onPrimary.withValues(alpha: 0.9),
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ⚪ WHITE SECTION
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FeatureItem(
                          text: 'feature_instant_payouts'.tr(),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        FeatureItem(
                          text: 'feature_transaction_history'.tr(),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        FeatureItem(
                          text: 'feature_easy_setup'.tr(),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // 🔗 Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            isLoading: false,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(AppSpacing.radiusLg),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: (_) => const LinkBankBottomSheet(),
                              );
                            },
                            title: 'link_my_bank'.tr(),
                            bgColor: primary,
                            textColor: onPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'bank_details_encrypted'.tr(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Icon(
                                Icons.verified_user,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 🫧 Painter for solid background + soft bubbles
class _BubblePainter extends CustomPainter {
  _BubblePainter({required this.primary, required this.onPrimary});
  final Color primary;
  final Color onPrimary;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..isAntiAlias = true;

    // Solid background
    paint.color = primary;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Subtle translucent bubbles
    paint.color = onPrimary.withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.25), 35, paint);

    paint.color = onPrimary.withValues(alpha: 0.08);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.5), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.25), 30, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({required this.text, required this.color, super.key});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          const Icon(Icons.circle, size: 6, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
