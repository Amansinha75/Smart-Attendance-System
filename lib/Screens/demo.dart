// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendence_system/Screens/HomePage.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  //final TextEditingController _employeeID = TextEditingController();
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordR = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isObscure = true;

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

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isObscure = _isObscure;
    return Scaffold(
      backgroundColor: const Color(0xFF425a70),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // for instruction part
              const SizedBox(height: 8),
              const Text(
                "Welcome to BSPHCL",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Create New Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              //
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Name
                      AutofillGroup(
                        child: TextFormField(
                          controller: _name,
                          autofillHints: const [AutofillHints.name],
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (_name.text.length <= 3) {
                              return "Invalid Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Your Name",
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),

                      /*employee ID
                            const SizedBox(height: 20),
                            AutofillGroup(
                              child: TextFormField(
                                controller: _employeeID,
                                autofillHints: const [AutofillHints.name],
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (_employeeID.text.length <= 3) {
                                    return "Invalid Name";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Employee ID",
                                  prefixIcon: Icon(Icons.man),
                                ),
                              ),
                            ), */

                      // Mail ID
                      const SizedBox(height: 20),
                      AutofillGroup(
                        child: TextFormField(
                          controller: _emailId,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            RegExp validateEmail = RegExp(
                                r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
                            if (!validateEmail.hasMatch(_emailId.text)) {
                              return "Invalid Email!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "Mail ID",
                              prefixIcon: Icon(Icons.mail)),
                        ),
                      ),

                      //Password
                      const SizedBox(height: 20),
                      TextFormField(
                          obscureText: _isObscure,
                          controller: _password,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (_password.text.length <= 5) {
                              return "Password should be more than 5 letters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Create Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          )),

                      //Repeat Password
                      const SizedBox(height: 20),
                      TextFormField(
                          obscureText: _isObscure,
                          controller: _passwordR,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (_passwordR.text.length <= 5) {
                              return "Password should be more than 5 letters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Re-Type Password",
                            prefixIcon: Icon(Icons.key),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          )),

                      //Phone Number
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_phone.text.length != 10) {
                            return "Invalid Phone Number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Contact Number",
                            prefixIcon: Icon(Icons.phone_android)),
                      ),
                    ],
                  ),
                ),
              ),

              // Create Account Buttom
              const SizedBox(height: 20),
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF06082E)),

                  //on-press buttom
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_password.text == _passwordR.text) {
                        try {
                          buildShowDialog(context);
                          UserCredential user =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailId.text,
                                  password: _password.text);
                          DatabaseReference ref = await FirebaseDatabase
                              .instance
                              .ref("Users/" + user.user!.uid.toString());
                          await ref.set({
                            "name": _name.text,
                            "password": _password.text,
                            "phone": _phone.text,
                            "email": _emailId.text,
                            // "employeeID": _employeeID.text,
                          });
                          Navigator.pop(context);
                          _showToast(context, 'Registration Successful');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                        companyname: '',
                                      )),
                              (route) => false);
                        } on FirebaseAuthException catch (e) {
                          Navigator.pop(context);
                          if (e.code == 'weak-password') {
                            _showToast(context, "Weak Password");
                            if (this.mounted) {
                              setState(() {
                                _password.text = "";
                                _passwordR.text = "";
                              });
                            }
                          } else if (e.code == 'email-already-in-use') {
                            Navigator.pop(context);
                            _showToast(context, 'Email Already Registered');
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          _showToast(context, "Some Unknown Occurred");
                        }
                      } else {
                        _showToast(context, "Password do not match");
                        if (this.mounted) {
                          setState(() {
                            _password.text = "";
                            _passwordR.text = "";
                          });
                        }
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
