import 'package:flutter/material.dart';
import 'widgets/cart_items_list_deprecated.dart';
import 'widgets/checkout_address_section.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          SimpleCheckoutAddressSection(),
          CartItemsList(),
          // SimplePostageSection(),
        ],
      ),
    );
  }
}
