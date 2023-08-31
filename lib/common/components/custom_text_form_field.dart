import 'package:delivery_app/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextFormField<T> extends StatelessWidget {
  final String name;
  final String? hinText, errorText, initialValue;
  final bool? obscureText, autofocus;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    super.key,
    required this.name,
    this.initialValue,
    this.hinText,
    this.errorText,
    this.autofocus = true,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1,
      ),
    );

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText!,
      autofocus: autofocus!,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hinText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
