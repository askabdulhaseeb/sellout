import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../services/get_it.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/params/order_return_params.dart';
import '../../../domain/usecase/order_return_usecase.dart';

Future<bool?> showRequestReturnBottomSheet({
  required BuildContext context,
  required OrderEntity order,
}) {
  final TextEditingController reasonCtrl = TextEditingController();
  bool isLoading = false;
  String reason = '';
  final String? objectId =
      (order.shippingDetails != null &&
          order.shippingDetails!.postage.isNotEmpty)
      ? order.shippingDetails!.postage.first.rateObjectId
      : null;

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext ctx2, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 4,
                          width: 10,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Text(
                        'request_return'.tr(),
                        style: Theme.of(ctx).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'reason_for_return'.tr(),
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: reasonCtrl,
                        maxLines: 4,
                        onChanged: (String v) => setState(() => reason = v),
                        decoration: InputDecoration(
                          hintText: 'enter_reason_here'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomElevatedButton(
                              isLoading: false,
                              onTap: () => Navigator.of(ctx).pop(false),
                              title: 'cancel'.tr(),
                              bgColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomElevatedButton(
                              title: 'request_return'.tr(),
                              isLoading: isLoading,
                              onTap: () {
                                if (isLoading) return;
                                if (reason.trim().isEmpty) {
                                  debugPrint(
                                    'requestReturn: blocked (empty reason) orderId=${order.orderId}',
                                  );
                                  return;
                                }
                                () async {
                                  FocusScope.of(ctx).unfocus();
                                  setState(() => isLoading = true);
                                  debugPrint(
                                    'requestReturn: start (orderId=${order.orderId}, objectId=$objectId, reasonLength=${reason.trim().length})',
                                  );
                                  final DataState<bool> res =
                                      await OrderReturnUsecase(locator()).call(
                                        OrderReturnParams(
                                          orderId: order.orderId,
                                          reason: reason.trim(),
                                          objectId: objectId,
                                        ),
                                      );
                                  if (!ctx.mounted) return;
                                  setState(() => isLoading = false);
                                  debugPrint(
                                    'requestReturn: done (${res.runtimeType}) orderId=${order.orderId}',
                                  );
                                  Navigator.of(
                                    ctx,
                                  ).pop(res is DataSuccess<bool>);
                                  if (res is DataSuccess<bool>) {
                                    AppSnackBar.success(
                                      context,
                                      'return_requested'.tr(),
                                    );
                                  } else {
                                    AppSnackBar.error(
                                      context,
                                      'failed_to_request_return'.tr(),
                                    );
                                  }
                                }();
                              },
                              bgColor: Theme.of(context).colorScheme.primary,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
