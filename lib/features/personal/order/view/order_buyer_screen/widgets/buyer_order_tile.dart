import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/order_tile_loader.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../../services/get_it.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/post_buy_now_button.dart';
import '../../../domain/entities/order_entity.dart';
import '../screen/order_buyer_screen.dart';

class BuyerOrderTileWidget extends StatefulWidget {
  const BuyerOrderTileWidget({super.key, required this.order});
  final OrderEntity order;

  @override
  State<BuyerOrderTileWidget> createState() => _BuyerOrderTileWidgetState();
}

class _BuyerOrderTileWidgetState extends State<BuyerOrderTileWidget> {
  late Future<DataState<PostEntity>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = GetSpecificPostUsecase(locator())
        .call(GetSpecificPostParam(postId: widget.order.postId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<PostEntity>>(
      future: futurePost,
      builder: (BuildContext context,
          AsyncSnapshot<DataState<PostEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const OrderTileLoader();
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text('Error loading post',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
        }

        if (!snapshot.hasData) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text('No post data',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
        }

        final DataState<PostEntity> state = snapshot.data!;

        if (state is DataFailer<List<PostEntity>>) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text(
                state.exception?.message ?? 'Failed to load post',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }

        if (state is DataSuccess<PostEntity>) {
          final PostEntity post = state.entity!;
          return GestureDetector(
            onTap: () => AppNavigator.pushNamed(OrderBuyerScreen.routeName,
                arguments: <String, OrderEntity>{'order': widget.order}),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomNetworkImage(
                      imageURL: post.imageURL,
                      placeholder: post.title,
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          spacing: 4,
                          children: <Widget>[
                            Flexible(
                              child: Text(widget.order.orderStatus.code.tr(),
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              child: Text(
                                  maxLines: 1,
                                  DateFormat('yyyy/MM/dd')
                                      .format(widget.order.updatedAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          fontSize: 8,
                                          color:
                                              ColorScheme.of(context).outline)),
                            ),
                          ],
                        ),
                        Text(post.title,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: ColorScheme.of(context).outline)),
                        Row(
                          spacing: 2,
                          children: <Widget>[
                            Flexible(
                              child: Text(post.priceStr,
                                  maxLines: 1,
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ),
                            Flexible(
                              child: Text('Rs+2',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: ColorScheme.of(context)
                                              .secondary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: Column(
                      spacing: 6,
                      children: <Widget>[
                        if (widget.order.orderStatus == StatusType.completed)
                          PostBuyNowButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.all(0),
                              detailWidgetColor: null,
                              detailWidgetSize: null,
                              detailWidget: false,
                              post: post,
                              buyNowText: 'buy_again'.tr(),
                              buyNowTextStyle: TextTheme.of(context)
                                  .labelSmall
                                  ?.copyWith(
                                      color:
                                          ColorScheme.of(context).onPrimary)),
                        if (widget.order.orderStatus == StatusType.pending)
                          CustomElevatedButton(
                            mWidth: 60,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            title: 'track_package'.tr(),
                            isLoading: false,
                            onTap: () {},
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                        CustomElevatedButton(
                          mWidth: 60,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          title: 'leave_feedback'.tr(),
                          isLoading: false,
                          onTap: () {},
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // Fallback if state type is unexpected
        return SizedBox(
          height: 80,
          child: Center(
            child: Text('Unknown state',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        );
      },
    );
  }
}
