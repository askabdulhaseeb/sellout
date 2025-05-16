import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../business/core/domain/entity/service/service_entity.dart';

class ServiceCardImageSection extends StatelessWidget {
  const ServiceCardImageSection({
    required this.service,
    super.key,
  });

  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomNetworkImage(imageURL: service.thumbnailURL),
      ),
    );
  }
}
