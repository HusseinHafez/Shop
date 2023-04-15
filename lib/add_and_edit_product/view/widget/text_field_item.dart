import 'package:flutter/material.dart';

import '../../../size_config.dart';

class TextFieldItem extends StatelessWidget {
  final String hint;
  final String? initValue;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final int? maxlines;
  final TextEditingController? controller;
  final bool? enabled;
  final bool scure;
  final Widget? suffixIcon;
 // final Function()? onPressedSuffixIcon;
  final Function(
    String string,
  )? onFieldSubmitted;
  final Function(
    String? string,
  )? onSaved;
  final Function(
    String string,
  )? onChange;
  final String? Function(
    String? string,
  )? validator;
  final TextInputAction? textInputAction;

  const TextFieldItem({
    Key? key,
    required this.hint,
    this.suffixIcon,
   // this.onPressedSuffixIcon,
    this.enabled,
    this.scure=false,
    this.initValue,
    this.validator,
    this.onChange,
    this.onSaved,
    this.controller,
    this.maxlines=1,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: TextFormField(

        enabled: enabled,
        obscureText: scure,
        initialValue: initValue,
        validator: validator,
        onChanged: onChange,
        onSaved: onSaved,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        keyboardType: textInputType,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: getFont(23),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(.3),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(.3),
            ),
          ),
          suffix: suffixIcon,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(.6),
        ),
        textInputAction: textInputAction,
        maxLines: maxlines,
      ),
    );
  }
}
