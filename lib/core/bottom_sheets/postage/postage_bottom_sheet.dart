import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../features/personal/post/data/sources/local/local_post.dart';
import '../../enums/listing/core/delivery_type.dart';
import '../../sources/api_call.dart';

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
    final CartProvider cartPro = context.read<CartProvider>();
    _selected = Map<String, RateEntity>.from(cartPro.selectedPostageRates);
  }

  void _setSelected(String postId, RateEntity rate) {
    setState(() {
      _selected[postId] = rate;
    });
  }

  void _applySelection(
      PostageDetailResponseEntity postage, CartProvider cartPro) {
    // Ensure each postId has a selected rate; if not, pick the first available or synthesize free
    postage.detail.forEach((String postId, PostageItemDetailEntity detail) {
      if (!_selected.containsKey(postId)) {
        final List<RateEntity> rates = detail.shippingDetails
            .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
            .toList();
        if (rates.isNotEmpty) {
          _selected[postId] = rates.first;
        } else {
          final bool isFreeDelivery =
              detail.originalDeliveryType.toLowerCase() == 'free' ||
                  detail.originalDeliveryType.toLowerCase() == 'collection' ||
                  (detail.message != null &&
                      detail.message!.toLowerCase().contains('free'));
          if (isFreeDelivery) {
            final RateEntity freeRate = RateEntity(
              amount: '0.00',
              provider: 'Free Delivery',
              providerImage75: '',
              providerImage200: '',
              amountBuffered: '0.00',
              serviceLevel: ServiceLevelEntity(name: 'Free', token: 'free'),
            );
            _selected[postId] = freeRate;
          }
        }
      }
    });

    _selected.forEach((String postId, RateEntity rate) {
      cartPro.selectPostageRate(postId, rate);
    });
    Navigator.of(context).pop(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartPro = context.read<CartProvider>();
    final PostageDetailResponseEntity postage =
        _cartPro.postageResponseEntity ?? widget.postage;
    final List<MapEntry<String, PostageItemDetailEntity>> entries =
        postage.detail.entries.toList();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PostageHeader(),
            const SizedBox(height: 8),
            PostageList(
              entries: entries,
              selected: _selected,
              onSelect: _setSelected,
              cartPro: _cartPro,
            ),
            PostageFooter(
              postage: postage,
              cartPro: _cartPro,
              onApply: () => _applySelection(postage, _cartPro),
            ),
          ],
        ),
      ),
    );
  }
}

class PostageHeader extends StatelessWidget {
  const PostageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Container(
          width: 40,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const PostageHeader(),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('postage_options'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('close'.tr())),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class PostageList extends StatelessWidget {
  const PostageList({
    required this.entries,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    Key? key,
  }) : super(key: key);

  final List<MapEntry<String, PostageItemDetailEntity>> entries;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final String postId = entries[index].key;
          final PostageItemDetailEntity detail = entries[index].value;
          return PostageItemCard(
            postId: postId,
            detail: detail,
            selected: selected,
            onSelect: onSelect,
            cartPro: cartPro,
          );
        },
      ),
    );
  }
}

class PostageItemCard extends StatelessWidget {
  const PostageItemCard({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    super.key,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostHeaderWidget(postId: postId),
          const SizedBox(height: 8),
          RatesSection(
            postId: postId,
            detail: detail,
            selected: selected,
            onSelect: onSelect,
            cartPro: cartPro,
          ),
        ],
      ),
    );
  }
}

class RatesSection extends StatelessWidget {
  const RatesSection({
    required this.postId,
    required this.detail,
    required this.selected,
    required this.onSelect,
    required this.cartPro,
    super.key,
  });

  final String postId;
  final PostageItemDetailEntity detail;
  final Map<String, RateEntity> selected;
  final void Function(String, RateEntity) onSelect;
  final CartProvider cartPro;

  @override
  Widget build(BuildContext context) {
    final List<RateEntity> rates = detail.shippingDetails
        .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();

    if (rates.isEmpty) {
      final String rawType = detail.originalDeliveryType;
      final DeliveryType displayType = DeliveryType.fromJson(rawType);

      Widget tag = Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: displayType.bgColor.withOpacity(1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: displayType.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.circle,
              size: 8,
              color: displayType.color.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              displayType.code.tr(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: displayType.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      );

      final bool offerRemoval = displayType != DeliveryType.freeDelivery;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              tag,
              const SizedBox(width: 12),
              if (detail.message != null)
                Expanded(
                    child: Text(detail.message!,
                        style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
          const SizedBox(height: 8),
          if (offerRemoval)
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    final bool confirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext ctx) => AlertDialog(
                            title: Text('remove_item'.tr()),
                            content:
                                Text('remove_item_delivery_unavailable'.tr()),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('cancel'.tr())),
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text('remove'.tr())),
                            ],
                          ),
                        ) ??
                        false;

                    if (!confirmed) return;

                    final DataState<bool> res =
                        await cartPro.removeItem(detail.id);
                    if (res is DataSuccess<bool> && res.entity == true) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('item_removed'.tr())));
                        Navigator.of(context).pop();
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(res.exception?.message ??
                                'remove_failed'.tr())));
                      }
                    }
                  },
                  child: Text('remove_item'.tr()),
                ),
              ],
            ),
        ],
      );
    }

    final RateEntity defaultRate = rates.first;
    final String defaultKey =
        '${defaultRate.provider}::${defaultRate.serviceLevel.token}::${defaultRate.amountBuffered.isNotEmpty ? defaultRate.amountBuffered : defaultRate.amount}';
    final String selectedKey = selected.containsKey(postId)
        ? '${selected[postId]!.provider}::${selected[postId]!.serviceLevel.token}::${selected[postId]!.amountBuffered.isNotEmpty ? selected[postId]!.amountBuffered : selected[postId]!.amount}'
        : defaultKey;

    return Column(
      children: rates.map((RateEntity rate) {
        final String label = '${rate.provider} · ${rate.serviceLevel.name}';
        final String key =
            '${rate.provider}::${rate.serviceLevel.token}::${rate.amountBuffered.isNotEmpty ? rate.amountBuffered : rate.amount}';
        return RadioListTile<String>(
          value: key,
          groupValue: selectedKey,
          onChanged: (String? k) {
            if (k == null) return;
            final RateEntity found = rates.firstWhere(
                (RateEntity rr) =>
                    '${rr.provider}::${rr.serviceLevel.token}::${rr.amountBuffered.isNotEmpty ? rr.amountBuffered : rr.amount}' ==
                    k,
                orElse: () => rate);
            onSelect(postId, found);
          },
          title: Row(
            children: <Widget>[
              if (rate.providerImage75.isNotEmpty)
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      rate.providerImage75,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (BuildContext ctx, Object err, StackTrace? st) =>
                              Container(
                        color: Theme.of(context).dividerColor,
                        child: const Icon(Icons.local_shipping, size: 16),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              Expanded(child: Text(label)),
            ],
          ),
          secondary: Text(
              rate.amountBuffered.isNotEmpty
                  ? rate.amountBuffered
                  : rate.amount,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          dense: true,
        );
      }).toList(),
    );
  }
}

class PostageFooter extends StatelessWidget {
  const PostageFooter({
    required this.postage,
    required this.cartPro,
    required this.onApply,
    super.key,
  });

  final PostageDetailResponseEntity postage;
  final CartProvider cartPro;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr())),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onApply, child: Text('apply'.tr())),
        ],
      ),
    );
  }
}

class PostHeaderWidget extends StatefulWidget {
  const PostHeaderWidget({required this.postId, super.key});
  final String postId;

  @override
  State<PostHeaderWidget> createState() => _PostHeaderWidgetState();
}

class _PostHeaderWidgetState extends State<PostHeaderWidget> {
  late final Future<dynamic> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = LocalPost().getPost(widget.postId, silentUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _postFuture,
      builder: (BuildContext c, AsyncSnapshot<dynamic> snap) {
        if (snap.hasError) return const Text('Error loading post');
        if (snap.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator(strokeWidth: 2);
        }

        final dynamic post = snap.data;
        return Row(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.image),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(post?.title ?? widget.postId)),
          ],
        );
      },
    );
  }
}
