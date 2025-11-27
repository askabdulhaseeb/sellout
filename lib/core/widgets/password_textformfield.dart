import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities/app_validators.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    required TextEditingController controller,
    this.textInputAction = TextInputAction.done,
    this.labelText = 'Password',
    this.readOnly = false,
    this.onFieldSubmitted,
    this.autofillHints,
    this.validator,
    super.key,
  }) : _controller = controller;

  final TextEditingController _controller;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final Iterable<String>? autofillHints;
  final String labelText;
  final bool readOnly;

  @override
  PasswordTextFormFieldState createState() => PasswordTextFormFieldState();
}

class PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _notVisible = true;
  void _onListener() => setState(() {});
  @override
  void initState() {
    widget._controller.addListener(_onListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.labelText,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          TextFormField(
            controller: widget._controller,
            obscureText: _notVisible,
            readOnly: widget.readOnly,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: widget.textInputAction,
            cursorColor: Theme.of(context).colorScheme.secondary,
            autofillHints:
                widget.autofillHints ?? const <String>[AutofillHints.password],
            validator: (String? value) => widget.validator == null
                ? AppValidator.password(value)
                : widget.validator!(value),
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: '********',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    _notVisible = !_notVisible;
                  }),
                  splashRadius: 16,
                  icon: (_notVisible == true)
                      ? const Icon(CupertinoIcons.eye)
                      : const Icon(CupertinoIcons.eye_slash),
                ),
                focusColor: Theme.of(context).primaryColor,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorScheme.of(context)
                          .onSurface
                          .withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
        ],
      ),
    );
  }
}
