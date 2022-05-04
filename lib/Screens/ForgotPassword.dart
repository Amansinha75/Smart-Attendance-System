// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF2F4464),
        body: Container(
          alignment: Alignment.center,
          color: const Color(0xFF425a70),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //for the instruction part
                    const SizedBox(height: 110),
                    const Text(
                      "To Reset your password Enter the following details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    //for Employee ID
                    const SizedBox(height: 45),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: "Enter Your Employee ID",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    //for EMail part part
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Enter your registered Mail ID",
                            prefixIcon: Icon(Icons.mail)),
                      ),
                    ),
                    //for "SUBMIT" buttom (with shared Preference used)
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 170.0,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              //sharedPreferences.setBool("LoggedIn", true);
                              Navigator.pushReplacementNamed(
                                  context, "/OTPsent");
                            },
                            child: const Text("Get OTP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF06082E)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
