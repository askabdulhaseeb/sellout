import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/text_display/empty_page_widget.dart';
import '../../../../../../core/widgets/loaders/seller_order_tile_loader.dart';
import '../../../../../../core/widgets/toggles/custom_toggle_switch.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import 'list_types/profile_order_tile.dart';

class ProfileOrdersSection extends StatefulWidget {
  const ProfileOrdersSection({required this.user, super.key});
  final UserEntity? user;

  @override
  State<ProfileOrdersSection> createState() => _ProfileOrdersSectionState();
}

class _ProfileOrdersSectionState extends State<ProfileOrdersSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ProfileProvider profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      profileProvider.getOrdersByStatus(widget.user?.uid ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pro, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomToggleSwitch<StatusType>(
                borderRad: 6,
                borderWidth: 0.5,
                horizontalPadding: 2,
                verticalPadding: 6,
                isShaded: false,
                selectedColors: <Color>[
                  StatusType.processing.color,
                  StatusType.shipped.color,
                  StatusType.delivered.color,
                  StatusType.canceled.color,
                ],
                unseletedBorderColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
                labelText: '',
                labels: const <StatusType>[
                  StatusType.pending,
                  StatusType.shipped,
                  StatusType.delivered,
                  StatusType.canceled,
                ],
                labelStrs: <String>[
                  'new_order'.tr(),
                  'dispatched'.tr(),
                  'delivered'.tr(),
                  'return'.tr(),
                ],
                initialValue: pro.status,
                onToggle: (StatusType val) {
                  pro.setStatus(val);
                  pro.getOrdersByStatus(widget.user?.uid ?? '');
                },
              ),
              const SizedBox(height: 8),
              if (pro.isLoading)
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return const SellerOrderTileLoader();
                  },
                )
              else if (pro.orders.isEmpty)
                Center(
                  child: EmptyPageWidget(
                    icon: CupertinoIcons.cube_box,
                    childBelow: Text('no_orders_found'.tr()),
                  ),
                )
              else
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pro.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final OrderEntity order = pro.orders[index];
                    return SellerOrderTile(order: order);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
