import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../providers/send_message_provider.dart';

class SendMessageField extends StatefulWidget {
  const SendMessageField({super.key});

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  late final SendMessageProvider _msgPro;

  @override
  void initState() {
    super.initState();
    _msgPro = Provider.of<SendMessageProvider>(context, listen: false);
    // Listen to focus changes to close emoji picker when keyboard opens
    _msgPro.messageFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_msgPro.messageFocusNode.hasFocus) {
      _msgPro.onTextFieldFocused();
    }
  }

  @override
  void dispose() {
    _msgPro.messageFocusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendMessageProvider>(
      builder: (_, SendMessageProvider msgPro, __) {
        return CustomTextFormField(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 4,
          ),
          dense: true,
          keyboardType: TextInputType.multiline,
          autoFocus: false,
          focusNode: msgPro.messageFocusNode,
          controller: msgPro.message,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          minLines: 1,
          maxLines: 5,
          hint: 'your_message_here'.tr(),
        );
      },
    );
  }
}
