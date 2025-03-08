import 'package:flutter/material.dart';

class CustomPinInputField extends StatefulWidget {
  const CustomPinInputField({
    required this.pinLength,
    required this.onChanged,
    super.key,
    this.fontSize = 20,
  });

  final int pinLength;
  final double fontSize;
  final ValueChanged<String> onChanged;

  @override
  CustomPinInputFieldState createState() => CustomPinInputFieldState();
}

class CustomPinInputFieldState extends State<CustomPinInputField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
        widget.pinLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updatePinCode() {
    String pinCode = _controllers
        .map((TextEditingController controller) => controller.text)
        .join();
    widget.onChanged(pinCode);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        widget.pinLength,
        (int index) => Container(
          width: 30,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (String value) {
              _updatePinCode();
              if (value.isNotEmpty && index < widget.pinLength - 1) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
