import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_network_image.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({required this.image, super.key});
  final String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: CustomNetworkImage(
        imageURL: image,
        placeholder: ' ',
      ),
    );
  }
}
