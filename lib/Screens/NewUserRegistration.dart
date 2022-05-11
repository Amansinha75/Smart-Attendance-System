// ignore_for_file: file_names, prefer_const_constructors, unnecessary_new, prefer_typing_uninitialized_variables, unused_local_variable, prefer_final_fields, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';

import 'HomePage.dart';

class NewUserRegistration extends StatefulWidget {
  const NewUserRegistration({Key? key}) : super(key: key);

  @override
  State<NewUserRegistration> createState() => _NewUserRegistrationState();
}

class _NewUserRegistrationState extends State<NewUserRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailID = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _employeeID = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordR = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //final DatabaseReference ref = FirebaseDatabase.instance.ref("users");

  var isObscure;

  get companyname => null;

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

  //int valueChoose = 0;
  //final List<String> listItems = ["BSPGCL", "BSPTCL", "SBPDCL", "NBPDCL"];


 /* addUserData() async {
    try {
      final newChild = ref.push();
      Map<String, String> data = {
        "name": _name.text,
        "email": _emailID.text,
        "password": _password.text,
        "passwordR": _passwordR.text,
        "employeeID": _employeeID.text,
        "phone": _phone.text
      };
      print(data);
      await FirebaseDatabase.instance
          .ref("users/" + newChild.key.toString())
          .set(data);

      _name.text = "";
      _emailID.text = "";
      _password.text = "";
      _employeeID.text = "";
      _phone.text = "";
    } catch (e) {}

    if (this.mounted) {
      setState(() {});
    }
  } */

  @override
  Widget build(BuildContext context) {
    bool isObscure = _isObscure;
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
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      /*child: Image.asset(
                        "image/BSPHCL_N.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),*/
                    ),
                    //for the instruction part
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

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //name
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Your Name",
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                              ),
                            ),

                            //employee ID
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
                            ),

                            //Mail ID
                            const SizedBox(height: 20),
                            AutofillGroup(
                              child: TextFormField(
                                controller: _emailID,
                                autofillHints: const [AutofillHints.email],
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp validateEmail = RegExp(
                                      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
                                  if (!validateEmail.hasMatch(_emailID.text)) {
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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

                            //Re-Type Password
                            const SizedBox(height: 20),
                            TextFormField(
                                obscureText: _isObscure,
                                controller: _passwordR,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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

                            //phone number
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Contact Number",
                                  prefixIcon: Icon(Icons.phone_android)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*for company name, with dropdown box
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(18)),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            isCollapsed: true,
                            enabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.house),
                          ),
                          hint: Text('Company Name'),
                          items: <String>[
                            'BSPGCL',
                            'BSPTCL',
                            'SBPDCL',
                            'NBPDCL',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ), */

                    //for "create account" buttom (with shared Preference used)
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 170.0,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_password.text == _passwordR.text) {
                                  try {
                                    buildShowDialog(context);
                                    UserCredential user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: _emailID.text,
                                            password: _password.text);
                                    DatabaseReference ref =
                                        await FirebaseDatabase.instance.ref(
                                            "Users/" +
                                                user.user!.uid.toString());
                                    await ref.set({
                                      "name": _name.text,
                                      "password": _password.text,
                                      "phone": _phone.text,
                                      "email": _emailID.text,
                                      "employeeID": _employeeID.text,
                                      "passwordR": _passwordR.text,

                                    });
                                    Navigator.pop(context);
                                    _showToast(
                                        context, 'Registration Successful');
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(companyname: '')),
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
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      Navigator.pop(context);
                                      _showToast(
                                          context, 'Email Already Registered');
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    _showToast(
                                        context, "Some Unknown Occurred");
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
                            child: const Text("Create Account",
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

class _auth {
  static createUserWithEmailAndPassword(
      {required String email, required String password}) {}
}
