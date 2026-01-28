import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../../../../../../../core/widgets/app_radio_tile.dart';

class DeliveryMethodDialog extends StatelessWidget {
  const DeliveryMethodDialog({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final DeliveryMethodModel model = Provider.of<DeliveryMethodModel>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _DialogHeader(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _ProductCard(post: post),
                        const SizedBox(height: 24),
                        const _DeliveryOptionsTitle(),
                        const SizedBox(height: 16),
                        _DeliveryOptions(model: model),
                        const SizedBox(height: 24),
                        _DialogActions(model: model),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
          Expanded(
            child: Center(
              child: Text(
                'Buy Now'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // To balance the IconButton width
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.post});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
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
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
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
                    (BuildContext context, AsyncSnapshot<double?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 18,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorScheme.primary,
                          ),
                        );
                      } else {
                        final double? price = snapshot.data;
                        return Text(
                          price != null
                              ? NumberFormat.simpleCurrency().format(price)
                              : '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: colorScheme.primary,
                          ),
                        );
                      }
                    },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeliveryOptionsTitle extends StatelessWidget {
  const _DeliveryOptionsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'How would you like to receive your order?'.tr(),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}

class _DeliveryOptions extends StatelessWidget {
  const _DeliveryOptions({required this.model});
  final DeliveryMethodModel model;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color iconBg(int value) =>
        model.selected == value ? colorScheme.primary : Colors.grey.shade200;
    Color iconColor(int value) =>
        model.selected == value ? Colors.white : Colors.grey.shade700;
    return Column(
      children: <Widget>[
        AppRadioTile<int>(
          value: 0,
          groupValue: model.selected,
          onChanged: (int? v) => model.selected = v!,
          iconWidget: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg(0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              color: iconColor(0),
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
              color: iconBg(1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: iconColor(1),
              size: 24,
            ),
          ),
          title: 'Pickup Point'.tr(),
          subtitle: 'Collect from a nearby location'.tr(),
        ),
      ],
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({required this.model});
  final DeliveryMethodModel model;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
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
              gradient: LinearGradient(
                colors: <Color>[colorScheme.primary, colorScheme.secondary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, model.selected == 1),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 1.1,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ),
      ],
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
