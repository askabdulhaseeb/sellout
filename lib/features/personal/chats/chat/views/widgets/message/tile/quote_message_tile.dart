import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
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
    debugPrint(message.quoteDetail?.status.json);
    final bool isMe = message.sendBy == LocalAuth.uid;
    final QuoteDetailEntity? quoteDetail = message.quoteDetail;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pinnedMessage ? 0 : 16),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: pinnedMessage
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outlineVariant)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (pinnedMessage)
            Divider(height: 1, color: Theme.of(context).dividerColor),
          if (pinnedMessage)
            Divider(height: 1, color: Theme.of(context).dividerColor),
          if (quoteDetail != null && quoteDetail.serviceEmployee.isNotEmpty)
            FutureBuilder<List<ServiceEntity?>>(
              future: Future.wait(
                quoteDetail.serviceEmployee.map(
                  (ServiceEmployeeEntity se) =>
                      LocalService().getService(se.serviceId),
                ),
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ServiceEntity?>> snapshot) {
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
                        debugPrint(
                            'quote details ${se.serviceId} ${se.bookAt}');
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: ColorScheme.of(context).outlineVariant,
                              width: 0.7,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 3.0),
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: <Widget>[
                              // LEFT SIDE — service name + quantity
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
                                    if (pinnedMessage)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          '×${se.quantity}',
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

                              // RIGHT SIDE — bookAt time
                              Text(
                                se.bookAt,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (quoteDetail.price != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${CountryHelper.currencySymbolHelper(message.quoteDetail?.currency)} ${quoteDetail.price.toString()}',
                            style: TextTheme.of(context).titleSmall,
                          ),
                        ],
                      ),
                    if (message.type == MessageType.quote)
                      Row(
                        spacing: 2,
                        children: <Widget>[
                          if (message.quoteDetail?.status == StatusType.pending)
                            Expanded(
                              child: CustomElevatedButton(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                bgColor: Colors.transparent,
                                textStyle: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor),
                                padding: const EdgeInsets.all(4),
                                title: 'decline'.tr(),
                                isLoading: false,
                                onTap: () => Provider.of<QuoteProvider>(context,
                                        listen: false)
                                    .updateQuote(UpdateQuoteParams(
                                        quoteId:
                                            message.quoteDetail?.quoteId ?? '',
                                        messageId: message.messageId,
                                        chatId: message.chatId,
                                        status: StatusType.canceled)),
                              ),
                            ),
                          if (message.quoteDetail?.status == StatusType.pending)
                            Expanded(
                              child: CustomElevatedButton(
                                textStyle: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                padding: const EdgeInsets.all(4),
                                title: 'pay_now'.tr(),
                                isLoading: false,
                                onTap: () {
                                  Provider.of<QuoteProvider>(context,
                                          listen: false)
                                      .holdQuotePay(HoldQuotePayParams(
                                          currency: quoteDetail.currency,
                                          quoteId: quoteDetail.quoteId));
                                },
                              ),
                            ),
                          if (message.quoteDetail?.status == StatusType.paid)
                            Expanded(
                              child: CustomElevatedButton(
                                isDisable: true,
                                textStyle: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                padding: const EdgeInsets.all(4),
                                title: 'paid'.tr(),
                                isLoading: false,
                                onTap: () {
                                  Provider.of<QuoteProvider>(context,
                                          listen: false)
                                      .holdQuotePay(HoldQuotePayParams(
                                          currency: quoteDetail.currency,
                                          quoteId: quoteDetail.quoteId));
                                },
                              ),
                            ),
                          if (message.quoteDetail?.status ==
                              StatusType.canceled)
                            Expanded(
                              child: CustomElevatedButton(
                                isDisable: true,
                                bgColor: Colors.transparent,
                                textStyle: TextTheme.of(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                padding: const EdgeInsets.all(4),
                                title: 'declined'.tr(),
                                isLoading: false,
                                onTap: () {},
                              ),
                            ),
                        ],
                      )
                  ],
                );
              },
            ),
          const SizedBox(height: 4),
          if (pinnedMessage)
            Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}
