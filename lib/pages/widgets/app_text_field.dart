
import 'package:flutter/services.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/widgets/required_label.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool required;
  final String hint;
  final double width;
  final bool password;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final bool enabled;



  AppTextField({
    this.label,
    this.required = false,
    this.hint,
    this.width,
    this.password = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.enabled,


  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RequiredLabel(label, required),
        _textField(context),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  _textField(context) {
    return Container(
      width: width ?? double.maxFinite,
      child: TextFormField(
        //key: Key(label),
        controller: controller,
        obscureText: password,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        enabled: enabled,


        onFieldSubmitted: (String text) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
//        border: OutlineInputBorder(
//          borderRadius: BorderRadius.circular(16)
//        ),
//          labelText: label,
          labelStyle: TextStyle(
            fontSize: 20,
            color: AppColors.blue,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
