import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/expandable_text_widget.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../../chats/create_chat/view/provider/create_private_chat_provider.dart';

class ServiceCardDetail extends StatelessWidget {
  const ServiceCardDetail({
    required this.service,
    super.key,
  });

  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  service.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextTheme.of(context)
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Provider.of<CreatePrivateChatProvider>(context,
                                listen: false)
                            .startPrivateChat(context, service.businessID);
                      },
                      icon: const Icon(CupertinoIcons.chat_bubble, size: 20)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.share, size: 20)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.archivebox, size: 20)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          ExpandableText(
            text: service.description,
          ),
        ],
      ),
    );
  }
}
