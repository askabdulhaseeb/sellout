import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../features/personal/post/data/sources/local/local_post.dart';

/// Bottom sheet to pick postage rates per post.
class PostageBottomSheet extends StatefulWidget {
  const PostageBottomSheet({required this.postage, super.key});
  final PostageDetailResponseEntity postage;

  @override
  State<PostageBottomSheet> createState() => _PostageBottomSheetState();
}

class _PostageBottomSheetState extends State<PostageBottomSheet> {
  late Map<String, RateEntity> _selected;

  @override
  void initState() {
    super.initState();
    // Start from provider's selected rates
    final CartProvider cartPro = context.read<CartProvider>();
    _selected = Map<String, RateEntity>.from(cartPro.selectedPostageRates);
  }

  void _setSelected(String postId, RateEntity rate) {
    setState(() {
      _selected[postId] = rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, PostageItemDetailEntity>> entries =
        widget.postage.detail.entries.toList();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Drag handle
            const SizedBox(height: 8),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('postage_options'.tr(),
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('close'.tr()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final String postId = entries[index].key;
                  final PostageItemDetailEntity detail = entries[index].value;
                  final RateEntity? selectedRate = _selected[postId];

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: ColorScheme.of(context).outlineVariant),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FutureBuilder<dynamic>(
                          future:
                              LocalPost().getPost(postId, silentUpdate: true),
                          builder:
                              (BuildContext c, AsyncSnapshot<dynamic> snap) {
                            final dynamic post = snap.data;
                            return Row(
                              children: <Widget>[
                                // small placeholder; keep image consistent in style with other sheets
                                SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: post?.imageURL != null
                                        ? Image.network(post.imageURL,
                                            fit: BoxFit.cover)
                                        : const SizedBox()),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(post?.title ?? postId,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Text(
                                          'items: ${detail.itemCount} · parcels: ${detail.parcelCount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        if (detail.shippingDetails.isEmpty)
                          Text('no_postage_options'.tr(),
                              style: Theme.of(context).textTheme.bodySmall)
                        else
                          Column(
                            children: detail.shippingDetails
                                .expand(
                                    (PostageDetailShippingDetailEntity sd) =>
                                        sd.ratesBuffered)
                                .map((RateEntity rate) {
                              final String label =
                                  '${rate.provider} · ${rate.serviceLevel.name} · ${rate.amount}';
                              return RadioListTile<RateEntity>(
                                value: rate,
                                groupValue: selectedRate,
                                onChanged: (RateEntity? r) {
                                  if (r != null) _setSelected(postId, r);
                                },
                                title: Text(label),
                                dense: true,
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('cancel'.tr()),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final CartProvider cartPro = context.read<CartProvider>();
                      // apply selected rates to provider
                      _selected.forEach((String postId, RateEntity rate) {
                        cartPro.selectPostageRate(postId, rate);
                      });
                      Navigator.of(context).pop(_selected);
                    },
                    child: Text('apply'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
