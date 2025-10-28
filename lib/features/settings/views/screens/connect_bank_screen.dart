import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utilities/app_string.dart';
import '../../../../core/widgets/custom_svg_icon.dart';

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
        title: Text('connect_bank_account'.tr()),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: CustomPaint(
            painter: _CardPainter(primary: primary, onPrimary: onPrimary),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 80,
                    height: 80,
                    child: CustomSvgIcon(
                      assetPath: AppStrings.selloutProfileBankIcon,
                      color: onPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'payouts_made_easy'.tr(),
                    style: TextStyle(
                      color: onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'connect_bank_description'.tr(),
                    style: TextStyle(
                      color: onPrimary.withOpacity(0.85),
                      fontSize: 13,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FeatureItem(
                    text: 'feature_instant_payouts'.tr(),
                    color: onPrimary.withOpacity(0.85),
                  ),
                  FeatureItem(
                    text: 'feature_transaction_history'.tr(),
                    color: onPrimary.withOpacity(0.85),
                  ),
                  FeatureItem(
                    text: 'feature_easy_setup'.tr(),
                    color: onPrimary.withOpacity(0.85),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: onPrimary,
                        foregroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 12,
                      ),
                      onPressed: () {},
                      child: Text(
                        'link_my_bank'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'bank_details_encrypted'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: onPrimary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.verified_user,
                    color: onPrimary.withOpacity(0.5),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Card painter for premium soft bubbles inside the card
class _CardPainter extends CustomPainter {
  final Color primary;
  final Color onPrimary;
  _CardPainter({required this.primary, required this.onPrimary});

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
