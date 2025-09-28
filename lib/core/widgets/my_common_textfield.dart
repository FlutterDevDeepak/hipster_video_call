import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  final String label;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool isReadOnly;
  final Color? labelColor;
  final Color? inputColor;
  final Color? borderColor;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final void Function()? onTap;
  final Function(String)? onCh;
  final InputDecoration? decoration;
  final int? maxline;
  final String hintlabel;
  final String prefixtxt;
  final FocusNode? focusNode;
  final TextCapitalization capitalization;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool autofocus;
  const MyTextFormField({
    super.key,
    required this.label,
    this.textInputAction,
    this.hintlabel = "",
    this.inputType = TextInputType.text,
    this.controller,
    this.isPasswordField = false,
    this.isReadOnly = false,
    this.labelColor = Colors.white,
    this.borderColor = Colors.white,
    this.inputColor = Colors.white,
    this.validator,
    this.onChange,
    this.decoration,
    this.onTap,
    this.onCh,
    this.focusNode,
    this.prefixtxt = "",
    this.maxline = 1,
    this.capitalization = TextCapitalization.words,
    this.maxLength,
    this.suffixIcon,
    this.autofocus = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(color: inputColor),
      validator: validator,
      maxLength: maxLength,
      textInputAction: textInputAction ?? TextInputAction.done,
      textCapitalization: capitalization,
      onChanged: onCh,
      onTap: onTap,
      maxLines: maxline,
      autofocus: autofocus,
      obscureText: isPasswordField,
      readOnly: isReadOnly,
      decoration:
          decoration ??
          InputDecoration(
            suffixIcon: suffixIcon,
            prefixText: prefixtxt,
            labelText: label,
            labelStyle: TextStyle(color: labelColor),
            fillColor: borderColor,
            hintText: hintlabel,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: (borderColor)!),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: (borderColor)!, width: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: (borderColor)!, width: 0.5),
            ),
          ),
    );
  }
}
