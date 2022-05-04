// main.dart
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class demo extends StatefulWidget {
  @override
  _demoState createState() => _demoState();
}

class _demoState extends State<demo> {
  GoogleTranslator translator = GoogleTranslator();
  String text = "Smart Attendence System";
  
  Future<void> translate() async {
    final res = await text.translate(from: 'en', to: 'hi');
    setState(() {
      text = res.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Demo"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text),
              ElevatedButton(
                onPressed: () async {
                  await translate();
                },
                child: Text("Translate"),
              )
            ],
          ),
        ));
  }
}

class GoogleTranslator {
  translate(String text, {required String to}) {}
}
