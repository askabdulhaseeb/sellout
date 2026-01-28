import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


import '../../../../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
/// Entry point: Use [BuyNowFlowButton] anywhere to trigger the Buy Now flow.
///
/// This widget is modular, reusable, and follows clean architecture principles.
/// All text uses localized keys and project conventions.

import '../../post_buy_now_button/post_buy_now_button.dart';

class BuyNowFlowButton extends StatelessWidget {
  const BuyNowFlowButton({
    required this.post,
    required this.detailWidget,
    required this.detailWidgetSize,
    required this.detailWidgetColor,
    this.buyNowText,
    this.buyNowTextStyle,
    this.buyNowColor,
    this.border,
    this.padding,
    this.margin,
    super.key,
  });

  final dynamic post;
  final bool detailWidget;
  final dynamic detailWidgetSize;
  final dynamic detailWidgetColor;
  final String? buyNowText;
  final TextStyle? buyNowTextStyle;
  final Color? buyNowColor;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return PostBuyNowButton(
      post: post,
      detailWidget: detailWidget,
      detailWidgetSize: detailWidgetSize,
      detailWidgetColor: detailWidgetColor,
      buyNowText: buyNowText,
      buyNowTextStyle: buyNowTextStyle,
      buyNowColor: buyNowColor,
      border: border,
      padding: padding,
      margin: margin,
      // Wrap the onTap to show the modal flow after add-to-cart logic
      // This requires a small change in PostBuyNowButton to accept an optional onSuccess callback
      onSuccess: () => _showBuyNowFlow(context),
    );
  }

  void _showBuyNowFlow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BuyNowFlowModal(
        post: post,
        detailWidget: detailWidget,
        detailWidgetSize: detailWidgetSize,
        detailWidgetColor: detailWidgetColor,
      ),
    );
  }
}

/// The main Buy Now flow modal, composed of modular steps.
class BuyNowFlowModal extends StatefulWidget {
  const BuyNowFlowModal({
    required this.post,
    required this.detailWidget,
    this.detailWidgetSize,
    this.detailWidgetColor,
    super.key,
  });

  final dynamic post;
  final bool detailWidget;
  final dynamic detailWidgetSize;
  final dynamic detailWidgetColor;

  @override
  State<BuyNowFlowModal> createState() => _BuyNowFlowModalState();
}

class _BuyNowFlowModalState extends State<BuyNowFlowModal> {
  int _step = 0;

  void _nextStep() => setState(() => _step++);
  void _prevStep() => setState(() => _step--);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStep(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 0:
        return BuyNowStepDeliveryMethod(
          onContinue: _nextStep,
          onCancel: () => Navigator.pop(context),
        );
      case 1:
        return BuyNowStepPickupLocation(
          onContinue: _nextStep,
          onBack: _prevStep,
        );
      case 2:
        return BuyNowStepShippingOption(
          onContinue: _nextStep,
          onBack: _prevStep,
        );
      case 3:
        return BuyNowStepOrderSummary(
          onPay: () => Navigator.pop(context),
          onBack: _prevStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// --- Modular Step Widgets ---

class BuyNowStepDeliveryMethod extends StatelessWidget {
  const BuyNowStepDeliveryMethod({
    required this.onContinue,
    required this.onCancel,
    super.key,
  });
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ...header, product card, etc.
        Text('how_would_you_like_to_receive_your_order'.tr()),
        // ...delivery method options
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                isLoading: false,
                title: 'cancel'.tr(),
                onTap: onCancel,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                isLoading: false,

                title: 'continue'.tr(),
                onTap: onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BuyNowStepPickupLocation extends StatelessWidget {
  const BuyNowStepPickupLocation({
    required this.onContinue,
    required this.onBack,
    super.key,
  });
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ...pickup location UI
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                title: 'back'.tr(),
                onTap: onBack,
                isLoading: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                isLoading: false,

                title: 'continue'.tr(),
                onTap: onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BuyNowStepShippingOption extends StatelessWidget {
  const BuyNowStepShippingOption({
    required this.onContinue,
    required this.onBack,
    super.key,
  });
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ...shipping option UI
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                title: 'back'.tr(),
                onTap: onBack,
                isLoading: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                isLoading: false,

                title: 'continue'.tr(),
                onTap: onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BuyNowStepOrderSummary extends StatelessWidget {
  const BuyNowStepOrderSummary({
    required this.onPay,
    required this.onBack,
    super.key,
  });
  final VoidCallback onPay;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ...order summary UI
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                title: 'back'.tr(),
                onTap: onBack,
                isLoading: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomElevatedButton(
                title: 'pay_now'.tr(),
                onTap: onPay,
                isLoading: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
