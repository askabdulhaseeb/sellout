import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/personal_setting_buyer_order_provider.dart';

class PersonalSettingBuyerOrderScreen extends StatefulWidget {
  const PersonalSettingBuyerOrderScreen({super.key});
  static const String routeName = 'personal-setting-myorders';
  @override
  State<PersonalSettingBuyerOrderScreen> createState() =>
      _PersonalSettingBuyerOrderScreenState();
}

class _PersonalSettingBuyerOrderScreenState
    extends State<PersonalSettingBuyerOrderScreen> {
  @override
  void initState() {
    super.initState();
    // Delay the call to after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PersonalSettingBuyerOrderProvider>(context, listen: false)
          .getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Consumer<PersonalSettingBuyerOrderProvider>(
        builder: (context, provider, _) {
          final orders = provider.orders;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) => Text(orders[index].orderId),
          );
        },
      ),
    );
  }
}
