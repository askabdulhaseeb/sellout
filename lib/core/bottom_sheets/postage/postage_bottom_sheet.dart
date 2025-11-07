import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../features/personal/basket/views/providers/cart_provider.dart';
import '../../../features/personal/post/data/sources/local/local_post.dart';

class PostageBottomSheet extends StatefulWidget {
  const PostageBottomSheet({required this.postage, super.key});
  final PostageDetailResponseEntity postage;

  @override
  State<PostageBottomSheet> createState() => _PostageBottomSheetState();
}

class _PostageBottomSheetState extends State<PostageBottomSheet> {
  late Map<String, RateEntity> _selected;

  String _rateKey(RateEntity r) =>
      '${r.provider}::${r.serviceLevel.token}::${r.amountBuffered.isNotEmpty ? r.amountBuffered : r.amount}';

  @override
  void initState() {
    super.initState();
    final CartProvider cartPro = context.read<CartProvider>();
    _selected = Map<String, RateEntity>.from(cartPro.selectedPostageRates);
  }

  // ✅ Fixed version of setSelected
  void _setSelected(String postId, RateEntity rate) {
    setState(() {
      _selected[postId] = rate;
    });
  }

  Widget _buildPostHeader(String postId) {
    return _PostHeaderWidget(postId: postId);
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
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildList(context, entries, _cartPro),
            _buildFooterActions(context, postage, _cartPro),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(2),
          ),
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
                child: Text('close'.tr()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildList(
      BuildContext context,
      List<MapEntry<String, PostageItemDetailEntity>> entries,
      CartProvider cartPro) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final String postId = entries[index].key;
          final PostageItemDetailEntity detail = entries[index].value;

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
                _buildPostHeader(postId),
                const SizedBox(height: 8),
                _buildRatesSection(postId, detail, cartPro),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatesSection(
      String postId, PostageItemDetailEntity detail, CartProvider cartPro) {
    final List<RateEntity> rates = detail.shippingDetails
        .expand((PostageDetailShippingDetailEntity sd) => sd.ratesBuffered)
        .toList();

    final bool isFreeDelivery =
        detail.originalDeliveryType.toLowerCase() == 'free' ||
            detail.originalDeliveryType.toLowerCase() == 'collection' ||
            (detail.message != null &&
                detail.message!.toLowerCase().contains('free'));

    if (rates.isEmpty) {
      if (isFreeDelivery) {
        final RateEntity freeRate = RateEntity(
          amount: '0.00',
          provider: 'Free Delivery',
          providerImage75: '',
          providerImage200: '',
          amountBuffered: '0.00',
          serviceLevel: ServiceLevelEntity(name: 'Free', token: 'free'),
        );

        final String selectedKey = _selected.containsKey(postId)
            ? _rateKey(_selected[postId]!)
            : _rateKey(freeRate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(detail.message ?? 'free_delivery'.tr(),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            RadioListTile<String>(
              value: _rateKey(freeRate),
              groupValue: selectedKey,
              onChanged: (String? key) {
                if (key == null) return;
                _setSelected(postId, freeRate);
              },
              title: const Text('Free Delivery'),
              secondary: Text(freeRate.amountBuffered,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              dense: true,
            ),
          ],
        );
      }

      return Text('no_postage_options'.tr(),
          style: Theme.of(context).textTheme.bodySmall);
    }

    final RateEntity defaultRate = rates.first;
    final String defaultKey = _rateKey(defaultRate);
    final String selectedKey = _selected.containsKey(postId)
        ? _rateKey(_selected[postId]!)
        : defaultKey;

    return Column(
      children: rates.map((RateEntity rate) {
        final String label = '${rate.provider} · ${rate.serviceLevel.name}';
        final String key = _rateKey(rate);
        return RadioListTile<String>(
          value: key,
          groupValue: selectedKey,
          onChanged: (String? k) {
            if (k == null) return;
            final RateEntity found = rates.firstWhere(
                (RateEntity rr) => _rateKey(rr) == k,
                orElse: () => rate);
            _setSelected(postId, found);
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

  Widget _buildFooterActions(BuildContext context,
      PostageDetailResponseEntity postage, CartProvider cartPro) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
              postage.detail
                  .forEach((String postId, PostageItemDetailEntity detail) {
                if (!_selected.containsKey(postId)) {
                  final List<RateEntity> rates = detail.shippingDetails
                      .expand((PostageDetailShippingDetailEntity sd) =>
                          sd.ratesBuffered)
                      .toList();
                  if (rates.isNotEmpty) {
                    _selected[postId] = rates.first;
                  } else {
                    final bool isFreeDelivery =
                        detail.originalDeliveryType.toLowerCase() == 'free' ||
                            detail.originalDeliveryType.toLowerCase() ==
                                'collection' ||
                            (detail.message != null &&
                                detail.message!.toLowerCase().contains('free'));
                    if (isFreeDelivery) {
                      final RateEntity freeRate = RateEntity(
                        amount: '0.00',
                        provider: 'Free Delivery',
                        providerImage75: '',
                        providerImage200: '',
                        amountBuffered: '0.00',
                        serviceLevel:
                            ServiceLevelEntity(name: 'Free', token: 'free'),
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
            },
            child: Text('apply'.tr()),
          ),
        ],
      ),
    );
  }
}

class _PostHeaderWidget extends StatefulWidget {
  const _PostHeaderWidget({required this.postId, Key? key}) : super(key: key);
  final String postId;

  @override
  State<_PostHeaderWidget> createState() => _PostHeaderWidgetState();
}

class _PostHeaderWidgetState extends State<_PostHeaderWidget> {
  late final Future<dynamic> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = LocalPost.openBox
        .then((_) => LocalPost().getPost(widget.postId, silentUpdate: true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _postFuture,
      builder: (BuildContext c, AsyncSnapshot<dynamic> snap) {
        if (snap.hasError) {
          return Text('Error loading post');
        }

        if (snap.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator(strokeWidth: 2);
        }

        final dynamic post = snap.data;
        return Row(
          children: [
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
            Expanded(
              child: Text(post?.title ?? widget.postId),
            ),
          ],
        );
      },
    );
  }
}
