import 'package:flutter/material.dart';
import 'package:done/constants.dart';

class inputField extends StatelessWidget {
  final textInputAction;
  final keyboardType;
  final String hint;
  final bool obscure;
  final Function onChanged;

  inputField(this.textInputAction, this.keyboardType, this.hint, this.obscure,
      this.onChanged);
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: kInputDecoration.copyWith(hintText: hint),
      onChanged: onChanged,
    );
  }
}
