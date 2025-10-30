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
    const Color primary = Colors.red;
    final Color onPrimary = theme.colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarTitle(
          titleKey: 'connect_bank_account',
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: CustomPaint(
            painter: _CardPainter(primary: primary, onPrimary: onPrimary),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    width: 80,
                    height: 80,
                    child: CustomSvgIcon(
                      assetPath: AppStrings.selloutProfileBankIcon,
                      color: onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'payouts_made_easy'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'connect_bank_description'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onPrimary.withValues(alpha: 0.85),
                      fontSize: 13,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FeatureItem(
                    text: 'feature_instant_payouts'.tr(),
                    color: onPrimary.withValues(alpha: 0.85),
                  ),
                  FeatureItem(
                    text: 'feature_transaction_history'.tr(),
                    color: onPrimary.withValues(alpha: 0.85),
                  ),
                  FeatureItem(
                    text: 'feature_easy_setup'.tr(),
                    color: onPrimary.withValues(alpha: 0.85),
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                          showDragHandle: false,
                          isScrollControlled: true,
                          builder: (BuildContext context) =>
                              const LinkBankBottomSheet(),
                        );
                      },
                      title: 'link_my_bank'.tr(),
                      bgColor: onPrimary,
                      textColor: primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'bank_details_encrypted'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: onPrimary.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Icon(
                    Icons.verified_user,
                    color: onPrimary.withValues(alpha: 0.5),
                    size: 24,
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

class FeatureItem extends StatelessWidget {
  const FeatureItem({required this.text, required this.color, super.key});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _CardPainter extends CustomPainter {
  _CardPainter({required this.primary, required this.onPrimary});
  final Color primary;
  final Color onPrimary;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..isAntiAlias = true;

    // Draw base card shape
    paint.color = primary;
    final RRect cardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(28),
    );
    canvas.drawRRect(cardRect, paint);

    // Soft translucent bubbles
    paint.color = onPrimary.withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 50, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.35), 35, paint);
    paint.color = onPrimary.withValues(alpha: 0.08);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.6), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.5), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
