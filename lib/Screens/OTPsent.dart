// ignore_for_file: file_names

import 'package:flutter/material.dart';

class OTPsent extends StatefulWidget {
  const OTPsent({Key? key}) : super(key: key);

  @override
  State<OTPsent> createState() => _OTPsentState();
}

class _OTPsentState extends State<OTPsent> {
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
                    const SizedBox(height: 70),
                    const Text(
                      "OTP sent successfully to your registered Mail ID ✔",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Please enter the OTP to reset your current Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //for OTP  part
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Enter OTP",
                            prefixIcon: Icon(Icons.password)),
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
                            onPressed: () => {
                              //sharedPreferences.setBool("LoggedIn", true);
                              Navigator.pushReplacementNamed(
                                  context, "/Resetpass")
                            },
                            child: const Text("Submit OTP",
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
