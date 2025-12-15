import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../services/get_it.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/return_eligibility_entity.dart';
import '../../../domain/params/return_eligibility_params.dart';
import '../../../domain/usecase/check_return_eligibility_usecase.dart';
import 'two_style_text.dart';

class OrderBuyerTrackingDetailsSection extends StatelessWidget {
  const OrderBuyerTrackingDetailsSection({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'tracking_details'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TwoStyleText(
          firstText: 'postal_service'.tr(),
          secondText:
              orderData.shippingDetails != null &&
                  orderData.shippingDetails!.postage.isNotEmpty
              ? (orderData.shippingDetails!.postage.first.serviceName ??
                    orderData.shippingDetails!.postage.first.provider ??
                    '-')
              : '-',
        ),
        TwoStyleText(
          firstText: 'courier'.tr(),
          secondText:
              orderData.shippingDetails != null &&
                  orderData.shippingDetails!.postage.isNotEmpty
              ? (orderData.shippingDetails!.postage.first.provider ?? '-')
              : '-',
        ),
        TwoStyleText(
          firstText: 'tracking_number'.tr(),
          secondText: orderData.trackId?.isNotEmpty == true
              ? orderData.trackId!
              : (orderData.shippingDetails != null &&
                        orderData.shippingDetails!.postage.isNotEmpty
                    ? (orderData.shippingDetails!.postage.first.shipmentId ??
                          '-')
                    : '-'),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (BuildContext subCtx) {
            final String rateObjectId =
                (orderData.shippingDetails != null &&
                    orderData.shippingDetails!.postage.isNotEmpty)
                ? (orderData.shippingDetails!.postage.first.rateObjectId ?? '')
                : '';

            return FutureBuilder<DataState<ReturnEligibilityEntity>>(
              future: CheckReturnEligibilityUsecase(locator()).call(
                ReturnEligibilityParams(
                  orderId: orderData.orderId,
                  objectId: rateObjectId,
                ),
              ),
              builder:
                  (
                    BuildContext ctx,
                    AsyncSnapshot<DataState<ReturnEligibilityEntity>> snap,
                  ) {
                    if (!snap.hasData) return const SizedBox();
                    final DataState<ReturnEligibilityEntity> state = snap.data!;
                    if (state is DataSuccess<ReturnEligibilityEntity>) {
                      final ReturnEligibilityEntity? ent = state.entity;
                      final bool allowed = ent?.allowed ?? false;
                      final String? reason = ent?.reason;
                      return Text(
                        allowed
                            ? 'return_eligible'.tr()
                            : (reason ?? 'return_not_eligible'.tr()),
                        style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                          color: allowed
                              ? Theme.of(ctx).colorScheme.primary
                              : Theme.of(ctx).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
            );
          },
        ),
      ],
    );
  }
}
