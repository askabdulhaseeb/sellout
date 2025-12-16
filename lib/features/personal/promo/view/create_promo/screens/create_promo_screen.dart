import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/promo_provider.dart';
import 'pages/promo_detail.dart';
import 'pages/promo_recorder.dart';

class CreatePromoScreen extends StatefulWidget {
  const CreatePromoScreen({super.key});
  static const String routeName = '/create-promo';

  @override
  State<CreatePromoScreen> createState() => _CreatePromoScreenState();
}

class _CreatePromoScreenState extends State<CreatePromoScreen> {
  @override
  Widget build(BuildContext context) {
    final PromoProvider pro = Provider.of<PromoProvider>(
      context,
      listen: false,
    );
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => pro.reset(),
      child: Scaffold(
        body: Center(
          child: Consumer<PromoProvider>(
            builder: (BuildContext context, PromoProvider pro, _) {
              return pro.pageNumber == 1
                  ? const CustomCameraScreen()
                  : const PromoDetailsForm();
            },
          ),
        ),
      ),
    );
  }
}
