import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/expandable_text_widget.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Provider.of<CreatePrivateChatProvider>(context,
                            listen: false)
                        .startPrivateChat(context, service.businessID);
                  },
                  child: const Icon(CupertinoIcons.chat_bubble, size: 16)),
              InDevMode(
                child: InkWell(
                    onTap: () {},
                    child: const Icon(CupertinoIcons.share, size: 16)),
              ),
              InDevMode(
                child: InkWell(
                    onTap: () {},
                    child: const Icon(CupertinoIcons.archivebox, size: 16)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  service.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextTheme.of(context)
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text('${service.currency} ${service.price.toString()}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextTheme.of(context).bodyMedium),
            ],
          ),
          ExpandableText(
            text: service.description,
          ),
        ],
      ),
    );
  }
}
