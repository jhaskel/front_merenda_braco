
import 'package:flutter/material.dart';
import 'package:merenda_escolar/core/app_colors.dart';


class AppTFF extends StatelessWidget {

  final String label;
  final String hint;
  final bool password;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType kType;
  final int maxLines;

  AppTFF({
    this.label,
    this.hint,
    this.password = false,
    this.controller,
    this.validator,
    this.kType=TextInputType.text,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15,left: 5),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        obscureText: password,
        validator: validator,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: const EdgeInsets.only(
              left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.green),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(10.0),


        ),


          //
        ),

      ),
    );
  }
}