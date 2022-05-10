// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smart_attendence_system/Screens/HomePage.dart';

// ignore: camel_case_types
class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

// ignore: camel_case_types
class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  Homepage(
                  companyname: '',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F4464),
      body: Center(
        // ignore: avoid_unnecessary_containers
        child: Container(
            child: Image.asset(
          "image/SBPDCL.png",
          fit: BoxFit.contain,
        )),
      ),
    );
  }
}
