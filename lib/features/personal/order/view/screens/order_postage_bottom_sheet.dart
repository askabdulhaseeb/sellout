import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../core/constants/app_spacings.dart';
import '../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../services/get_it.dart';
import '../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../postage/domain/params/add_order_label_params.dart';
import '../../../../postage/domain/params/get_order_postage_detail_params.dart';
import '../../../../postage/domain/usecase/add_order_shipping_usecase.dart';
import '../../../../postage/domain/usecase/get_order_postage_detail_usecase.dart';
import 'order_postage_item_card.dart';

class OrderPostageBottomSheet extends StatefulWidget {
  const OrderPostageBottomSheet({required this.orderId, super.key});
  final String orderId;

  @override
  State<OrderPostageBottomSheet> createState() =>
      _OrderPostageBottomSheetState();
}

class _OrderPostageBottomSheetState extends State<OrderPostageBottomSheet> {
  late Future<DataState<PostageDetailResponseEntity>> _future;
  final Map<String, RateEntity> _selectedRates = <String, RateEntity>{};

  @override
  void initState() {
    super.initState();
    _future = GetOrderPostageDetailUsecase(
      locator(),
    ).call(GetOrderPostageDetailParam(orderId: widget.orderId));
  }

  RateEntity? get _selectedRate {
    if (_selectedRates.isEmpty) return null;
    return _selectedRates.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FutureBuilder<DataState<PostageDetailResponseEntity>>(
          future: _future,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<DataState<PostageDetailResponseEntity>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData ||
                    snapshot.data
                        is! DataSuccess<PostageDetailResponseEntity>) {
                  return SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'no_shipping_options_available'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                final PostageDetailResponseEntity postage =
                    (snapshot.data as DataSuccess<PostageDetailResponseEntity>)
                        .entity!;
                final List<PostageItemDetailEntity> entries = postage.detail;
                if (entries.isEmpty) {
                  return SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'no_shipping_options_available'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'postage_options'.tr(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        cacheExtent: 5000,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (BuildContext context, int index) {
                          final PostageItemDetailEntity detail = entries[index];
                          return OrderPostageItemCard(
                            detail: detail,
                            selectedRateId:
                                _selectedRates[detail.postId]?.objectId,
                            onRateSelected: (RateEntity rate) {
                              setState(() {
                                _selectedRates[detail.postId] = rate;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          isLoading: false,
                          title: 'buy_label'.tr(),
                          onTap: _selectedRate != null
                              ? () {
                                  AddOrderShippingUsecase(locator())
                                      .call(
                                        AddOrderShippingParams(
                                          orderId: widget.orderId,
                                          objectId: _selectedRate!.objectId,
                                        ),
                                      )
                                      .then((DataState<bool> result) {
                                        if (result is DataSuccess<bool> &&
                                            result.entity == true) {
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'failed_to_add_shipping'.tr(),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                }
                              : () {},
                        ),
                      ),
                    ),
                  ],
                );
              },
        ),
      ),
    );
  }
}
