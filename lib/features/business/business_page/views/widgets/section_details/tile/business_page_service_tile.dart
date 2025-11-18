import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../../core/domain/entity/service/service_entity.dart';
import '../../../../../service/views/providers/add_service_provider.dart';
import '../../../../../service/views/screens/add_service_screen.dart';

class BusinessPageServiceTile extends StatelessWidget {
  const BusinessPageServiceTile({required this.service, super.key});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    final bool isMe = LocalAuth.currentUser?.businessID == service.businessID;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: SizedBox(
        height: 100,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CustomNetworkImage(
                  imageURL: service.thumbnailURL,
                  placeholder: service.name,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 6),
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${service.time} mins',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
                  if (isMe)
                    SizedBox(
                      width: 50,
                      child: CustomElevatedButton(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(4),
                        onTap: () {
                          final AddServiceProvider pro =
                              Provider.of<AddServiceProvider>(context,
                                  listen: false);
                          pro.reset();
                          pro.setService(service);
                          Navigator.pushNamed(
                              context, AddServiceScreen.routeName);
                        },
                        isLoading: false,
                        title: 'edit'.tr(),
                        textStyle:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                        bgColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(height: 24),
                Text(
                  '${service.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  service.currency,
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
