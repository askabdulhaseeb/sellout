import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import 'enter_code_screen.dart';

class SendCodeScreen extends StatefulWidget {
  const SendCodeScreen({super.key});
  static const String routeName = '/send-code';

  @override
  _SendCodeScreenState createState() => _SendCodeScreenState();
}

class _SendCodeScreenState extends State<SendCodeScreen> {
  int _selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: const SellOutTitle(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text('send_code_title'.tr(),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(
              height: 4,
              width: double.infinity,
            ),
            Text('send_code_description'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text('send_via_email'.tr()),
              subtitle: const Text('zubair@gmail.com'),
              leading: Radio<int>(
                value: 0,
                groupValue: _selectedOption,
                onChanged: (int? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('send_via_sms'.tr()),
              subtitle: const Text('+44 7742023323'),
              leading: Radio<int>(
                value: 1,
                groupValue: _selectedOption,
                onChanged: (int? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('login_with_password'.tr()),
              leading: Radio<int>(
                value: 2,
                groupValue: _selectedOption,
                onChanged: (int? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 100,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'not_you?'.tr(),
                  isLoading: false,
                  textColor: ColorScheme.of(context).onSurface,
                  bgColor: ColorScheme.of(context).surface,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  onTap: () => Navigator.pop(context)),
            ),
            Flexible(
              child: CustomElevatedButton(
                margin: const EdgeInsets.all(10),
                title: 'continue'.tr(),
                isLoading: false,
                onTap: () {
                  Navigator.pushNamed(context, EnterCodeScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
