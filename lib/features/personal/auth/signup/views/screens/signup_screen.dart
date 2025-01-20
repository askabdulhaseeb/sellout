import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/signup_provider.dart';
import '../widgets/signup_page_progress_bar_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = '/sign-up';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {
      Provider.of<SignupProvider>(context, listen: false).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const SellOutTitle(),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back_rounded),
          onPressed: () => Provider.of<SignupProvider>(context, listen: false)
              .onBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<SignupProvider>(
          builder: (BuildContext context, SignupProvider pro, _) {
            return Column(
              children: <Widget>[
                const SignupPageProgressBarWidget(),
                const SizedBox(height: 16),
                Expanded(child: pro.displayedPage()),
              ],
            );
          },
        ),
      ),
    );
  }
}
