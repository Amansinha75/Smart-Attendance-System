// ignore: file_names
import 'package:flutter/material.dart';

class ResetPasswordSuccessfully extends StatefulWidget {
  const ResetPasswordSuccessfully({Key? key}) : super(key: key);

  @override
  State<ResetPasswordSuccessfully> createState() =>
      _ResetPasswordSuccessfullyState();
}

class _ResetPasswordSuccessfullyState extends State<ResetPasswordSuccessfully> {
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
                      "Password Reset Successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Please Login to go to HomePage",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
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
                              Navigator.pushReplacementNamed(context, "/Home")
                            },
                            child: const Text("Login",
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
