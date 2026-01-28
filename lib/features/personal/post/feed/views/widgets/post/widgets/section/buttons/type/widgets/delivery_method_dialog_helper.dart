import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'delivery_method_dialog.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';

class DeliveryMethodDialogHelper {
  static Future<bool?> show(BuildContext context, PostEntity post) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangeNotifierProvider<DeliveryMethodModel>(
        create: (_) => DeliveryMethodModel(),
        child: DeliveryMethodDialog(post: post),
      ),
    );
  }
}
