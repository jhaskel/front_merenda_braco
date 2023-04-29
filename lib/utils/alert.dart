

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


alert(BuildContext context, String msg, {Function callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Merenda Escolar"),
          content: Text("$msg"),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}

alertConfirm(BuildContext context, String msg, {Function confirmCallback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Carros"),
          content: Text(msg),
          actions: <Widget>[
            MaterialButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.pop(context);
                if (confirmCallback != null) {
                  confirmCallback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}
void toast(BuildContext context,String msg, {int duration, int gravity}) {
  Toast.show(msg, context, duration: duration, gravity: gravity);
}