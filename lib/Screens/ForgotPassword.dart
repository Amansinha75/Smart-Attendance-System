// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailId = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(
            label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

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
                      "To Reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "Enter your registered Mail ID",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    //for Email part part
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AutofillGroup(
                              child: TextFormField(
                                controller: _emailId,
                                autofillHints: const [AutofillHints.email],
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  RegExp validateEmail = RegExp(
                                      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
                                  if (!validateEmail.hasMatch(_emailId.text)) {
                                    return "Invalid Email!!!";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: "Enter your registered Mail ID",
                                    prefixIcon: Icon(Icons.mail)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //for "SUBMIT" buttom (with shared Preference used)
                    const SizedBox(height: 40),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 170.0,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await _auth.sendPasswordResetEmail(
                                      email: _emailId.text);
                                  _showToast(context,
                                      "Password Resent Sent Successfully");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                                companyname: '',
                                              )),
                                      (route) => false);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    _showToast(context, "Email ID Not Found");
                                  }
                                }
                              }
                            },
                            child: const Text("SUBMIT",
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
