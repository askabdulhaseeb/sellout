import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/loaders/loader_container.dart';
import '../../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../quote/domain/entites/quote_detail_entity.dart';
import '../../../../../quote/domain/entites/service_employee_entity.dart';
import '../../../../../quote/domain/params/hold_quote_pay_params.dart';
import '../../../../../quote/domain/params/update_quote_params.dart';
import '../../../../../quote/view/provider/quote_provider.dart';
import '../common/currency_display.dart';
import '../common/message_container.dart';

class QuoteMessageTile extends StatelessWidget {
  const QuoteMessageTile({
    required this.message,
    required this.pinnedMessage,
    super.key,
  });

  final MessageEntity message;
  final bool pinnedMessage;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == LocalAuth.uid;
    final QuoteDetailEntity? quoteDetail = message.quoteDetail;

    return MessageContainer(
      showBorder: !pinnedMessage,
      borderRadius: 6,
      margin: EdgeInsets.symmetric(horizontal: pinnedMessage ? 0 : 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (pinnedMessage)
            Divider(height: 1, color: Theme.of(context).dividerColor),
          if (quoteDetail != null && quoteDetail.serviceEmployee.isNotEmpty)
            _QuoteServicesSection(
              message: message,
              quoteDetail: quoteDetail,
              pinnedMessage: pinnedMessage,
            ),
          const SizedBox(height: 4),
          if (pinnedMessage)
            Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}

class _QuoteServicesSection extends StatelessWidget {
  const _QuoteServicesSection({
    required this.message,
    required this.quoteDetail,
    required this.pinnedMessage,
  });

  final MessageEntity message;
  final QuoteDetailEntity quoteDetail;
  final bool pinnedMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ServiceEntity?>>(
      future: Future.wait(
        quoteDetail.serviceEmployee.map(
          (ServiceEmployeeEntity se) => LocalService().getService(se.serviceId),
        ),
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<ServiceEntity?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderContainer(
                height: 40,
                width: double.infinity,
                borderRadius: 6,
              );
            }
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final List<ServiceEntity?> services = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.displayText,
                  style: TextTheme.of(context).titleSmall,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: quoteDetail.serviceEmployee.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ServiceEmployeeEntity se =
                        quoteDetail.serviceEmployee[index];
                    final String serviceName =
                        services[index]?.name ?? 'na'.tr();
                    return _ServiceRow(
                      serviceName: serviceName,
                      serviceEmployee: se,
                      showQuantity: pinnedMessage,
                    );
                  },
                ),
                if (quoteDetail.price != 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CurrencyDisplay(
                      currency: quoteDetail.currency,
                      price: quoteDetail.price,
                      style: TextTheme.of(context).titleSmall,
                    ),
                  ),
                if (message.type == MessageType.quote)
                  _QuoteActionButtons(
                    message: message,
                    quoteDetail: quoteDetail,
                  ),
              ],
            );
          },
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.serviceName,
    required this.serviceEmployee,
    required this.showQuantity,
  });

  final String serviceName;
  final ServiceEmployeeEntity serviceEmployee;
  final bool showQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: ColorScheme.of(context).outlineVariant,
          width: 0.7,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    serviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showQuantity)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      '×${serviceEmployee.quantity}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            serviceEmployee.bookAt,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QuoteActionButtons extends StatelessWidget {
  const _QuoteActionButtons({required this.message, required this.quoteDetail});

  final MessageEntity message;
  final QuoteDetailEntity quoteDetail;

  @override
  Widget build(BuildContext context) {
    final StatusType? status = message.quoteDetail?.status;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        spacing: 2,
        children: <Widget>[
          if (status == StatusType.pending) ...<Widget>[
            Expanded(
              child: CustomElevatedButton(
                border: Border.all(color: Theme.of(context).primaryColor),
                bgColor: Colors.transparent,
                textStyle: TextTheme.of(
                  context,
                ).bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.all(4),
                title: 'decline'.tr(),
                isLoading: false,
                onTap: () => _handleDecline(context),
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                textStyle: TextTheme.of(context).bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                padding: const EdgeInsets.all(4),
                title: 'pay_now'.tr(),
                isLoading: false,
                onTap: () => _handlePay(context),
              ),
            ),
          ],
          if (status == StatusType.paid)
            Expanded(
              child: CustomElevatedButton(
                isDisable: true,
                textStyle: TextTheme.of(context).bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                padding: const EdgeInsets.all(4),
                title: 'paid'.tr(),
                isLoading: false,
                onTap: () {},
              ),
            ),
          if (status == StatusType.canceled)
            Expanded(
              child: CustomElevatedButton(
                isDisable: true,
                bgColor: Colors.transparent,
                textStyle: TextTheme.of(context).bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                padding: const EdgeInsets.all(4),
                title: 'declined'.tr(),
                isLoading: false,
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }

  void _handleDecline(BuildContext context) {
    Provider.of<QuoteProvider>(context, listen: false).updateQuote(
      UpdateQuoteParams(
        quoteId: message.quoteDetail?.quoteId ?? '',
        messageId: message.messageId,
        chatId: message.chatId,
        status: StatusType.canceled,
      ),
    );
  }

  void _handlePay(BuildContext context) {
    Provider.of<QuoteProvider>(context, listen: false).holdQuotePay(
      HoldQuotePayParams(
        currency: quoteDetail.currency,
        quoteId: quoteDetail.quoteId,
      ),
    );
  }
}
