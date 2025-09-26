import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/loaders/loader_container.dart';
import '../../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../quote/domain/entites/quote_detail_entity.dart';
import '../../../../../quote/domain/entites/service_employee_entity.dart';
import '../../../../../quote/domain/params/update_quote_params.dart';
import '../../../../../quote/view/provider/quote_provider.dart';

class QuoteMessageTile extends StatelessWidget {
  const QuoteMessageTile({
    required this.message,
    required this.showButtons,
    super.key,
  });

  final MessageEntity message;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == LocalAuth.uid;
    final QuoteDetailEntity? quoteDetail = message.quoteDetail;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Row(
            children: <Widget>[
              if (message.quoteDetail?.status == StatusType.canceled)
                Expanded(
                  child: CustomElevatedButton(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    bgColor: Colors.transparent,
                    textStyle: TextTheme.of(context)
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    title: 'cancel'.tr(),
                    isLoading: false,
                    onTap: () =>
                        Provider.of<QuoteProvider>(context, listen: false)
                            .updateQuote(UpdateQuoteParams(
                                quoteId: message.quoteDetail?.quoteId ?? '',
                                messageId: message.messageId,
                                chatId: message.chatId,
                                status: StatusType.canceled)),
                  ),
                ),
              if (message.quoteDetail?.status == StatusType.accepted)
                Expanded(
                  child: CustomElevatedButton(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    bgColor: Colors.transparent,
                    textStyle: TextTheme.of(context)
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(4),
                    title: 'accept'.tr(),
                    isLoading: false,
                    onTap: () =>
                        Provider.of<QuoteProvider>(context, listen: false)
                            .updateQuote(UpdateQuoteParams(
                                quoteId: message.quoteDetail?.quoteId ?? '',
                                messageId: message.messageId,
                                chatId: message.chatId,
                                status: StatusType.canceled)),
                  ),
                ),
            ],
          ),
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

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: quoteDetail.serviceEmployee.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ServiceEmployeeEntity se =
                        quoteDetail.serviceEmployee[index];
                    final String serviceName =
                        services[index]?.name ?? 'na'.tr();
                    debugPrint('quote details ${se.serviceId} ${se.bookAt}');
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
                          // ✅ No nested Row, just Expanded
                          Expanded(
                            flex: 4,
                            child: Text(
                              serviceName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '×${se.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              se.bookAt,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          const SizedBox(height: 4),
          Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}
