import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Temp2 extends StatelessWidget {
  String _url = 'https://www.youtube.com/embed/R0tHEJl_Y8E?start=68';
  void _launch() async {
    await canLaunch(_url)
        ? await launch(_url, forceSafariVC: false, forceWebView: false)
        : throw 'Could not launch url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyan),
      body: SingleChildScrollView(
        child: Container(
            child: Center(
          child: ElevatedButton(
            child: Text('press'),
            onPressed: () {
              _launch();
            },
          ),
        )),
      ),
    );
  }
}
