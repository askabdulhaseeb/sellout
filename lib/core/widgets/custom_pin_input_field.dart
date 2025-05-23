import 'package:flutter/material.dart';

class CustomPinInputField extends StatefulWidget {
  const CustomPinInputField({
    required this.pinLength,
    required this.onChanged,
    this.gap = 12,
    this.fillColor,
    this.fontSize = 16,
    this.obscureText = false,
    this.keyboardType = TextInputType.number,
    this.validator,
    super.key,
  });

  final int pinLength;
  final double gap;
  final Color? fillColor;
  final double fontSize;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  CustomPinInputFieldState createState() => CustomPinInputFieldState();
}

class CustomPinInputFieldState extends State<CustomPinInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.pinLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(
      widget.pinLength,
      (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _updatePinCode() {
    final String pinCode =
        _controllers.map((TextEditingController c) => c.text).join();
    widget.onChanged(pinCode);
  }

  // void _handlePaste(String value) {
  //   if (value.length == widget.pinLength) {
  //     for (int i = 0; i < widget.pinLength; i++) {
  //       _controllers[i].text = value[i];
  //     }
  //     _updatePinCode();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: widget.gap,
              children: List<Widget>.generate(widget.pinLength, (int index) {
                return SizedBox(
                  width: 30,
                  height: 40,
                  child: TextFormField(
                    cursorHeight: 20,
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: widget.keyboardType,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    obscureText: widget.obscureText,
                    obscuringCharacter: '•',
                    style: TextTheme.of(context).bodySmall?.copyWith(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: widget.fillColor != null,
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: ColorScheme.of(context).outlineVariant,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (String value) {
                      if (value.isNotEmpty) {
                        if (index < widget.pinLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      } else if (index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }

                      _updatePinCode();
                      field.didChange(_controllers.map((e) => e.text).join());
                    },
                    onTap: () {
                      if (_controllers[index].text.isNotEmpty) {
                        _controllers[index].selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
