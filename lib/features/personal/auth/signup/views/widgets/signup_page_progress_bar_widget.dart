import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/signup_page_type.dart';
import '../providers/signup_provider.dart';

class SignupPageProgressBarWidget extends StatelessWidget {
  const SignupPageProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
        builder: (BuildContext context, SignupProvider pro, _) {
      int courrentIndex = pro.currentPage.index;
      int totalIndex = SignupPageType.values.length;
      return Row(
        children: <Widget>[
          Expanded(
            child: LinearProgressIndicator(
              value: pro.currentPage.index / SignupPageType.values.length,
              backgroundColor: Theme.of(context).dividerColor,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text('$courrentIndex/$totalIndex'),
        ],
      );
    });
  }
}
