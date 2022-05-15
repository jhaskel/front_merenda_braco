import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';

class PrintButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  PrintButton({@required this.onPressed,this.color});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          Icons.print,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
