import 'package:flutter/material.dart';
import 'widgets/checkout_address_section.dart';
import 'widgets/checkout_postage_section.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SimpleCheckoutAddressSection(),
          SizedBox(height: 12),
          SimplePostageSection(),
        ],
      ),
    );
  }
}
