import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required TextEditingController? controller,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.autofillHints,
    this.initialValue,
    this.hint = '',
    this.labelText = '',
    this.color,
    this.contentPadding,
    this.minLines,
    this.maxLines = 1,
    this.isExpanded = false,
    this.maxLength,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.showSuffixIcon = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.textAlign = TextAlign.start,
    this.style,
    this.border,
    super.key,
  }) : _controller = controller;

  final TextEditingController? _controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showSuffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Color? color;
  final String? initialValue;
  final String? hint;
  final String labelText;
  final bool readOnly;
  final bool isExpanded;
  final bool autoFocus;
  final TextAlign textAlign;
  final InputBorder? border;
  final TextStyle? style;
  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  void _onListen() => setState(() {});
  final List<TextInputFormatter> inputFormatters = [];
  @override
  void initState() {
    widget._controller!.addListener(_onListen);
    inputFormatters.addAll(widget.inputFormatters ?? <TextInputFormatter>[]);
    if (widget.maxLength != null) {
      inputFormatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }
    if (widget.keyboardType == TextInputType.number ||
        widget.keyboardType ==
            const TextInputType.numberWithOptions(decimal: true) ||
        widget.keyboardType == TextInputType.phone) {
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')));
    }
    super.initState();
  }

  @override
  void dispose() {
    widget._controller!.removeListener(_onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.labelText.isNotEmpty)
            Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          if (widget.labelText.isNotEmpty) const SizedBox(height: 2),
          TextFormField(
            initialValue: widget.initialValue,
            controller: widget._controller,
            readOnly: widget.readOnly,
            inputFormatters: inputFormatters,
            keyboardType: widget.keyboardType == TextInputType.number
                ? const TextInputType.numberWithOptions(decimal: true)
                : widget.maxLines! > 1
                    ? TextInputType.multiline
                    : widget.keyboardType ?? TextInputType.text,
            textInputAction: widget.maxLines! > 1
                ? TextInputAction.unspecified
                : widget.textInputAction ?? TextInputAction.next,
            autofillHints: widget.autofillHints,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign,
            onChanged: widget.onChanged,
            minLines: widget.isExpanded ? widget.maxLines : widget.minLines,
            maxLines: widget.isExpanded
                ? widget.maxLines
                : (widget._controller!.text.isEmpty)
                    ? 1
                    : widget.maxLines,
            maxLength: widget.isExpanded ? widget.maxLength : null,
            style: widget.style,
            validator: (String? value) =>
                widget.validator == null ? null : widget.validator!(value),
            onFieldSubmitted: widget.onFieldSubmitted,
            cursorColor: Theme.of(context).colorScheme.secondary,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              // filled: true,
              // fillColor: widget.color ??
              //     Theme.of(context)
              //         .textTheme
              //         .bodyLarge!
              //         .color!
              //         .withOpacity(0.05),
              hintText: widget.hint,
              prefixText:
                  widget.prefixText == null ? null : '${widget.prefixText!} ',
              prefixIcon: widget.prefixIcon,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              suffixIcon: widget.suffixIcon ??
                  ((widget._controller!.text.isEmpty ||
                          !widget.showSuffixIcon ||
                          widget.showSuffixIcon == false ||
                          widget.readOnly)
                      ? (widget.maxLength == null
                          ? null
                          : widget.isExpanded
                              ? null
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${widget._controller!.text.length}/${widget.maxLength}',
                                      style: TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ))
                      : IconButton(
                          splashRadius: 16,
                          onPressed: () => setState(() {
                            widget._controller!.clear();
                          }),
                          icon: const Icon(CupertinoIcons.clear, size: 18),
                        )),
              focusColor: Theme.of(context).primaryColor,
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.circular(4.0),
              ),
              border: widget.border ??
                  OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
