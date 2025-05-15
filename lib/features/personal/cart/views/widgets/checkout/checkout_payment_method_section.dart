import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../providers/cart_provider.dart';

class CheckoutPaymentMethodSection extends StatefulWidget {
  const CheckoutPaymentMethodSection({super.key});

  @override
  State<CheckoutPaymentMethodSection> createState() =>
      _CheckoutPaymentMethodSectionState();
}

class _CheckoutPaymentMethodSectionState
    extends State<CheckoutPaymentMethodSection> {
  int? selectedIndex;

  final List<Map<String, String>> paymentMethods = <Map<String, String>>[
    <String, String>{
      'image': AppStrings.applePayBlack,
      'title': 'google_pay',
    },
    <String, String>{
      'image': AppStrings.applePayBlack,
      'title': 'apple_pay',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
    final String clientSecret = pro.orderBilling?.clientSecret ?? '';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: paymentMethods.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, String> method = paymentMethods[index];
                final bool isSelected = selectedIndex == index;
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  leading: Checkbox(
                    activeColor: Colors.red,
                    value: isSelected,
                    onChanged: (_) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  title: Row(
                    children: <Widget>[
                      Image.asset(method['image']!, width: 30),
                      const SizedBox(width: 12),
                      Text(method['title']!),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryColor,
            ),
            label: const Text('add_new_card'),
            style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: AppTheme.primaryColor.withAlpha(0x33),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            onTap: () async {
              if (selectedIndex == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('')),
                );
                return;
              }
              if (clientSecret.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Client secret is missing')),
                );
                return;
              }
              try {
                await pro.presentStripePaymentSheet(clientSecret);
                // On success:
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => const PaymentSuccessSheet(),
                );
              } catch (e) {
                // On failure, show error bottom sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => PaymentErrorSheet(message: e.toString()),
                );
              }
            },
            title: 'confirm_payment'.tr(),
            isLoading: false,
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessSheet extends StatelessWidget {
  const PaymentSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
              ),
              Text(
                'payment_successful'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'payment_successful_description'.tr(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.check_circle_outline_rounded,
                  color: AppTheme.primaryColor, size: 60),
              const SizedBox(height: 16),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: 100,
          child: CustomElevatedButton(
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(color: ColorScheme.of(context).onSurface),
            textColor: ColorScheme.of(context).onSurface,
            onTap: () {
              AppNavigator.pushNamedAndRemoveUntil(
                  DashboardScreen.routeName, (_) => false);
            },
            title: 'continue'.tr(),
            isLoading: false,
          ),
        ),
      ),
    );
  }
}

class PaymentErrorSheet extends StatelessWidget {
  final String message;

  const PaymentErrorSheet({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Payment Failed!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Try Again'),
            ),
          ),
        ],
      ),
    );
  }
}
