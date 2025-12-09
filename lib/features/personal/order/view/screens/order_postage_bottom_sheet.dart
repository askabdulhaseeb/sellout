import 'package:flutter/material.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../../../services/get_it.dart';
import '../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../postage/domain/params/get_order_postage_detail_params.dart';
import '../../../../postage/domain/usecase/get_order_postage_detail_usecase.dart';
import 'order_postage_item_card.dart';

class OrderPostageBottomSheet extends StatefulWidget {
  const OrderPostageBottomSheet({required this.orderId, super.key});
  final String orderId;

  @override
  State<OrderPostageBottomSheet> createState() =>
      _OrderPostageBottomSheetState();
}

class _OrderPostageBottomSheetState extends State<OrderPostageBottomSheet> {
  late Future<DataState<PostageDetailResponseEntity>> _future;
  PostageItemDetailEntity? _selectedDetail;

  @override
  void initState() {
    super.initState();
    _future = GetOrderPostageDetailUsecase(
      locator(),
    ).call(GetOrderPostageDetailParam(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FutureBuilder<DataState<PostageDetailResponseEntity>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<DataState<PostageDetailResponseEntity>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData ||
                snapshot.data is! DataSuccess<PostageDetailResponseEntity>) {
              return Center(child: Text('No shipping options available.'));
            }
            final PostageDetailResponseEntity postage =
                (snapshot.data as DataSuccess<PostageDetailResponseEntity>)
                    .entity!;
            final List<PostageItemDetailEntity> entries = postage.detail;
            if (entries.isEmpty) {
              return Center(child: Text('No shipping options available.'));
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Choose Postage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    cacheExtent: 5000,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final PostageItemDetailEntity detail = entries[index];
                      return OrderPostageItemCard(
                        detail: detail,
                        selected: _selectedDetail == detail,
                        onSelect: () {
                          setState(() {
                            _selectedDetail = detail;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _selectedDetail != null
                        ? () {
                            // TODO: Call buy label usecase with selected detail
                          }
                        : null,
                    child: const Text('Buy Label'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
