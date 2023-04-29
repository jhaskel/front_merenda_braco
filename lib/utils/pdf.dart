

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({Key key}) : super(key: key);

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {


  final _url = 'https://firebasestorage.googleapis.com/v0/b/app-merenda-escolar.appspot.com/o/agrolandia%2Fordem%2F220115116%2F531913523.pdf?alt=media&token=afc1759d-7559-4c83-9b67-c44b38523d44';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: _launchURL,
        child: Text('Show Flutter homepage'),
      ),
    );
  }
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}



