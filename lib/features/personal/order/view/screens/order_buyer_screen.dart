// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
// import 'package:provider/provider.dart';
// import '../../../../../core/sources/data_state.dart';
// import '../../../../../services/get_it.dart' show locator;
// import '../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
// import '../../../post/domain/entities/post_entity.dart';
// import '../../../post/domain/params/get_specific_post_param.dart';
// import '../../../post/domain/usecase/get_specific_post_usecase.dart'
//     show GetSpecificPostUsecase;
// import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
// import '../../domain/entities/order_entity.dart';
// import '../provider/order_provider.dart';

class OrderBuyerScreen extends StatelessWidget {
  const OrderBuyerScreen({super.key});
  static String routeName = '/order-buyer-screen';

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final String orderId = args['order-id'] ?? '';
    // final OrderProvider orderPro =
    //     Provider.of<OrderProvider>(context, listen: false);
    // if (orderPro.order?.orderId != orderId) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     orderPro.loadOrder(orderId);
    //   });
    // }

    // return Selector<OrderProvider, OrderEntity?>(
    //   selector: (_, OrderProvider provider) => provider.order,
    //   builder: (BuildContext context, OrderEntity? order, _) {
    //     if (order == null) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(titleKey: 'order_details'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TwoStyleText(firstText: 'POst sn', secondText: 'trertert'),
              TwoStyleText(firstText: 'right hu', secondText: 'qwerty'),
              TwoStyleText(
                  firstText: 'Filopic',
                  secondText: '123456hiwertyuhjimkcfvgybhnjkm'),
              TwoStyleText(firstText: 'No. ruu', secondText: 'trertert'),
              SizedBox(),
              HorizontalProgressIndicator(
                currentStep: 2,
                steps: <String>['processing', 'dispatched', 'delivered'],
              )
            ],
          ),
        ));
  }

  //       final bool isBusiness = order.sellerId.startsWith('BU');
  //       final GetSpecificPostUsecase getPostUsecase =
  //           GetSpecificPostUsecase(locator());
  //       final GetUserByUidUsecase getUserUsecase =
  //           GetUserByUidUsecase(locator());
  //       final GetBusinessByIdUsecase getBusinessUsecase =
  //           GetBusinessByIdUsecase(locator());

  //       return Scaffold(
  //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //         appBar: AppBar(
  //           centerTitle: true,
  //           title: Text(
  //             'order_details'.tr(),
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .bodyLarge
  //                 ?.copyWith(fontWeight: FontWeight.w500),
  //           ),
  //           leading: IconButton(
  //             style: IconButton.styleFrom(
  //               backgroundColor:
  //                   Theme.of(context).colorScheme.outline.withAlpha(25),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             icon: const Icon(Icons.arrow_back_ios_new_rounded),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ),
  //         body: FutureBuilder<DataState<PostEntity>>(
  //           future: getPostUsecase(GetSpecificPostParam(postId: order.postId)),
  //           builder: (BuildContext context,
  //               AsyncSnapshot<DataState<PostEntity>> postSnap) {
  //             if (postSnap.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //             final PostEntity? post = postSnap.data?.entity;
  //             if (post == null) {
  //               return Center(child: Text('something_wrong'.tr()));
  //             }

  //             return FutureBuilder<DataState<dynamic>>(
  //               future: isBusiness
  //                   ? getBusinessUsecase(order.sellerId)
  //                   : getUserUsecase(order.sellerId),
  //               builder: (BuildContext context,
  //                   AsyncSnapshot<DataState<dynamic>> userSnap) {
  //                 if (userSnap.connectionState == ConnectionState.waiting) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 }
  //                 return SizedBox.shrink();
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}

class TwoStyleText extends StatelessWidget {
  const TwoStyleText({
    required this.firstText,
    required this.secondText,
    super.key,
  });
  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      maxLines: 1,
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '$firstText: ',
            style: TextTheme.of(context).bodyLarge?.copyWith(
                  color: ColorScheme.of(context).outline,
                ),
          ),
          TextSpan(
            text: secondText,
            style: TextTheme.of(context).bodyLarge?.copyWith(
                  color: ColorScheme.of(context).onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class HorizontalProgressIndicator extends StatelessWidget {
  const HorizontalProgressIndicator({
    required this.currentStep,
    required this.steps,
    super.key,
  });

  final int currentStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final int totalSteps = steps.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: List.generate(totalSteps * 2 - 1, (int index) {
            if (index.isEven) {
              final int step = index ~/ 2 + 1;
              return Expanded(child: Center(child: _buildPoint(context, step)));
            } else {
              final int stepBefore = (index ~/ 2) + 1;
              return _buildLine(context, stepBefore);
            }
          }),
        ),
        const SizedBox(height: 4),
        // --- Labels aligned under each circle ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (int index) {
            return Text(
              steps[index],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPoint(BuildContext context, int step) {
    final bool isActive = step == currentStep;
    final bool isCompleted = step < currentStep;

    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveColor = Theme.of(context).dividerColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? activeColor : Colors.transparent,
        border: Border.all(
          color: isActive || isCompleted ? activeColor : inactiveColor,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: isCompleted
              ? Colors.white
              : (isActive ? Colors.white : Colors.transparent),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildLine(BuildContext context, int stepBefore) {
    final bool isCompleted = stepBefore < currentStep;
    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveColor = Theme.of(context).dividerColor;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isCompleted ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
