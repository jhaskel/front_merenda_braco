


import 'package:flutter/material.dart';

class EmpenhoPage extends StatefulWidget {
  const EmpenhoPage({Key key}) : super(key: key);

  @override
  _EmpenhoPageState createState() => _EmpenhoPageState();
}

class _EmpenhoPageState extends State<EmpenhoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),

    );
  }

  _body() {
    return Center(child: Text("Empenho"),);
  }
}
