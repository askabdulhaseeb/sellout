import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../services/get_it.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/params/order_return_params.dart';
import '../../../domain/usecase/order_return_usecase.dart';

Future<bool?> showRequestReturnBottomSheet({
  required BuildContext context,
  required OrderEntity order,
  PostEntity? post,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return _RequestReturnBottomSheet(order: order, post: post);
    },
  );
}

class _RequestReturnBottomSheet extends StatefulWidget {
  const _RequestReturnBottomSheet({required this.order, this.post});

  final OrderEntity order;
  final PostEntity? post;

  @override
  State<_RequestReturnBottomSheet> createState() =>
      _RequestReturnBottomSheetState();
}

class _RequestReturnBottomSheetState extends State<_RequestReturnBottomSheet> {
  String? _selectedReason;
  final TextEditingController _otherReasonCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _returnReasons = <String>[
    'item_arrived_damaged',
    'wrong_item_received',
    'item_doesnt_match_description',
    'quality_not_as_expected',
    'changed_my_mind',
    'other',
  ];

  String? get _objectId =>
      (widget.order.shippingDetails != null &&
          widget.order.shippingDetails!.postage.isNotEmpty)
      ? widget.order.shippingDetails!.postage.first.rateObjectId
      : null;

  String get _finalReason {
    if (_selectedReason == 'other') {
      return _otherReasonCtrl.text.trim();
    }
    return _selectedReason?.tr() ?? '';
  }

  Future<void> _submitReturn() async {
    if (_isLoading) return;

    final String reason = _finalReason;
    if (reason.isEmpty) {
      setState(() => _errorMessage = 'please_select_reason'.tr());
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final DataState<bool> result = await OrderReturnUsecase(locator()).call(
      OrderReturnParams(
        orderId: widget.order.orderId,
        reason: reason,
        objectId: _objectId,
      ),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result is DataSuccess<bool>) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _errorMessage = 'failed_to_request_return'.tr());
    }
  }

  @override
  void dispose() {
    _otherReasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Header with back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // Title
                Text(
                  'return_this_item'.tr(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'return_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product info card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      // Product image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.post?.imageURL != null
                            ? Image.network(
                                widget.post!.imageURL,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 56,
                                  height: 56,
                                  color: colors.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : Container(
                                width: 56,
                                height: 56,
                                color: colors.surfaceContainerHighest,
                                child: Icon(
                                  Icons.image,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.post?.title ?? 'product'.tr(),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${'order'.tr()} #${widget.order.orderId.length > 20 ? widget.order.orderId.substring(0, 20) : widget.order.orderId}...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${'qty'.tr()}: ${widget.order.quantity} - \$${widget.order.price.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reason selection title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'why_returning_item'.tr(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Reason options
                ...List<Widget>.generate(_returnReasons.length, (int index) {
                  final String reason = _returnReasons[index];
                  final bool isSelected = _selectedReason == reason;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: InkWell(
                      onTap: () => setState(() {
                        _selectedReason = reason;
                        _errorMessage = null;
                      }),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.05)
                              : null,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.outline,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colors.primary,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                reason.tr(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? colors.primary
                                      : colors.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Other reason text field
                if (_selectedReason == 'other') ...<Widget>[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _otherReasonCtrl,
                      maxLines: 3,
                      onChanged: (_) => setState(() => _errorMessage = null),
                      decoration: InputDecoration(
                        hintText: 'enter_reason_here'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Error message
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.errorContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: colors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Info banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.info_outline, color: colors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'return_info_message'.tr(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Expanded(
                    child: CustomElevatedButton(
                      title: 'request_return'.tr(),
                      isLoading: _isLoading,
                      onTap: _submitReturn,
                      bgColor: colors.error,
                      textStyle: TextStyle(color: colors.onError),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
