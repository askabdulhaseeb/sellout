import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../../../../../../../../core/widgets/app_radio_tile.dart';

class DeliveryMethodDialog extends StatelessWidget {
  const DeliveryMethodDialog({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DeliveryMethodModel>(context);
    Color _iconBg(int value) => model.selected == value
        ? const Color(0xFFD32F2F)
        : Colors.grey.shade200;
    Color _iconColor(int value) =>
        model.selected == value ? Colors.white : Colors.grey.shade700;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Product Card
            Row(
              children: <Widget>[
                // Product image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.imageURL,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            );
                          },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<double?>(
                        future: post.getLocalPrice(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<double?> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 18,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error'.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFFD32F2F),
                                  ),
                                );
                              } else {
                                final double? price = snapshot.data;
                                return Text(
                                  price != null
                                      ? NumberFormat.simpleCurrency().format(
                                          price,
                                        )
                                      : '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFFD32F2F),
                                  ),
                                );
                              }
                            },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'How would you like to receive your order?'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            AppRadioTile<int>(
              value: 0,
              groupValue: model.selected,
              onChanged: (int? v) => model.selected = v!,
              iconWidget: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg(0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: _iconColor(0),
                  size: 24,
                ),
              ),
              title: 'Home Delivery'.tr(),
              subtitle: 'Delivered to your address'.tr(),
            ),
            const SizedBox(height: 12),
            AppRadioTile<int>(
              value: 1,
              groupValue: model.selected,
              onChanged: (int? v) => model.selected = v!,
              iconWidget: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg(1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: _iconColor(1),
                  size: 24,
                ),
              ),
              title: 'Pickup Point'.tr(),
              subtitle: 'Collect from a nearby location'.tr(),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      textStyle: const TextStyle(fontSize: 16),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text('Cancel'.tr()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFD32F2F), Color(0xFF009688)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, model.selected == 1),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DeliveryMethodModel extends ChangeNotifier {
  int _selected = 0;
  int get selected => _selected;
  set selected(int v) {
    if (_selected != v) {
      _selected = v;
      notifyListeners();
    }
  }
}
