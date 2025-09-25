import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../../quote/domain/entites/quote_detail_entity.dart';
import '../../../../../quote/domain/entites/service_employee_entity.dart';

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
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          if (showButtons)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: CustomElevatedButton(
                title: 'Create Quote',
                isLoading: false,
                onTap: () {},
              ),
            ),
          if (quoteDetail != null && quoteDetail.serviceEmployee.isNotEmpty)
            FutureBuilder<List<ServiceEntity?>>(
              future: Future.wait(
                quoteDetail.serviceEmployee.map((ServiceEmployeeEntity se) =>
                    LocalService().getService(se.serviceId)),
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ServiceEntity?>> snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading services...',
                      style: TextStyle(fontSize: 13, color: Colors.black54));
                }

                final List<ServiceEntity?> services = snapshot.data!;
                // Build a single compact line per service
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    quoteDetail.serviceEmployee.length,
                    (int index) {
                      final ServiceEmployeeEntity se =
                          quoteDetail.serviceEmployee[index];
                      final String serviceName = services[index]?.name ??
                          'Service ID: ${se.serviceId}';
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: ColorScheme.of(context).outlineVariant)),
                        padding: const EdgeInsets.all(2.0),
                        margin: const EdgeInsets.all(2.0),
                        child: Row(
                          spacing: 4,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                serviceName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text('×${se.quantity}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const Spacer(),
                            Text(se.bookAt,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
