import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_network_image.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({required this.post, super.key});
  final String post;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: CustomNetworkImage(imageURL: post),
    );
  }
}
