import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function onPressed;

  EditButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          Icons.edit,
          color: AppColors.blue,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
