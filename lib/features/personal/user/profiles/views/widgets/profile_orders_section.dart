import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';

class ProfileOrdersSection extends StatefulWidget {
  const ProfileOrdersSection({super.key, this.user});

  final UserEntity? user;

  @override
  State<ProfileOrdersSection> createState() => _ProfileOrdersSectionState();
}

class _ProfileOrdersSectionState extends State<ProfileOrdersSection> {
  String selectedStatus = 'New Orders'; // Default selection

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro = Provider.of<ProfileProvider>(context);

    return Column(
      children: <Widget>[
        CustomToggleSwitch<String>(
          labels: const <String>['New Orders', 'completed', 'Cancelled'],
          labelStrs: const <String>['New Orders', 'completed', 'Cancelled'],
          labelText: 'Select Order Status',
          initialValue: selectedStatus,
          onToggle: (String value) {
            setState(() {
              selectedStatus = value;
            });
          },
        ),
        FutureBuilder<DataState<List<OrderEntity>?>>(
          future: pro.getOrderByUser(widget.user?.uid ?? ''),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<List<OrderEntity>?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.data == null) {
              return const Center(child: Text("No orders found."));
            }

            List<OrderEntity> allOrders = snapshot.data!.entity!;
            List<OrderEntity> filteredOrders =
                allOrders.where((OrderEntity order) {
              return order.paymentDetail.status ==
                  selectedStatus; // Filter by status
            }).toList();

            if (filteredOrders.isEmpty) {
              return const Center(child: Text('No orders in this category.'));
            }

            return SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredOrders.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const CustomNetworkImage(
                              imageURL: '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(filteredOrders[index].orderId,
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              Text(
                                  '\$${filteredOrders[index].price}', // Assuming price exists in OrderEntity
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              Text('sale_completed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.green)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
