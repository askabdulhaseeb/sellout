import 'package:flutter/material.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../widgets/post/home_post_list_section.dart';
import '../widgets/promo/home_promo_list_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HomePromoListSection(),
          HomePostListSection(),
        ],
      ),
    ));
  }
}
