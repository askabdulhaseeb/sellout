import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/domain/entity/service/service_entity.dart';

class BusinessPageServiceTile extends StatelessWidget {
  const BusinessPageServiceTile({required this.service, super.key});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    log('service: ${service.attachments.length} - ${service.thumbnailURL}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: SizedBox(
        height: 80,
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
