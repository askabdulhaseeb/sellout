import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool _isPasting = false;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.pinLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(
      widget.pinLength,
      (index) {
        final node = FocusNode();
        node.addListener(() {
          if (node.hasFocus) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _selectAllText(index);
            });
          }
        });
        return node;
      },
    );
  }

  void _selectAllText(int index) {
    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controllers[index].text.length,
      );
    }
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
  //     _isPasting = true;
  //     for (int i = 0; i < widget.pinLength; i++) {
  //       _controllers[i].text = value[i];
  //     }
  //     _isPasting = false;
  //     _updatePinCode();
  //     _focusNodes[widget.pinLength - 1].requestFocus();
  //   }
  // }

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      // Handle backspace on empty field
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      }
      // Handle arrow keys
      else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (index < widget.pinLength - 1) {
          _focusNodes[index + 1].requestFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: widget.gap,
              children: List<Widget>.generate(widget.pinLength, (int index) {
                return RawKeyboardListener(
                  focusNode: FocusNode(skipTraversal: true),
                  onKey: (event) => _handleKeyEvent(event, index),
                  child: SizedBox(
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
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
                        if (_isPasting) return;

                        if (value.isNotEmpty) {
                          // Replace existing digit and move to next
                          if (index < widget.pinLength - 1) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        } else {
                          // Clear current field and move to previous
                          if (index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        }

                        _updatePinCode();
                        field.didChange(_controllers.map((c) => c.text).join());
                      },
                    ),
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
