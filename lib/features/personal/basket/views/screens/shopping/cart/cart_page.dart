import 'package:flutter/material.dart';
import 'pages/personal_cart_cart_item_list.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {


  @override
  Widget build(BuildContext context) {
    return const PersonalCartItemList();
  }
}
