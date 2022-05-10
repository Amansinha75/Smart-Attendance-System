// ignore: file_names
// ignore_for_file: unnecessary_const, prefer_const_constructors, unused_import, unused_local_variable, unused_field, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/HomePage.dart';
import 'package:smart_attendence_system/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final String companyname;
  const LoginPage({Key? key, required this.companyname}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  get floatingActionButtonLocation => null;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //for the shared Preferences part, to be directed from login page to homepage
  late SharedPreferences sharedPreferences;
  bool loggedin = false;

  final DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  bool loaded = false;
  // ignore: prefer_final_fields, unused_field
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

  Future<void> ini() async {
    // Get data from docs and convert map to List
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool('LoggedIn') != null) {
      loggedin = sharedPreferences.getBool('LoggedIn')!;
    }

    if (loggedin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homepage(
                    companyname: widget.companyname,
                  )));
    } else {
      setState(() {
        loaded = true;
      });
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    ini();
  }

  @override
  Widget build(BuildContext context) {
    var isObscure = _isObscure;
    return Scaffold(
        backgroundColor: const Color(0xFF2F4464),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
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
                      child: Image.asset(
                        "image/BSPHCL_N.png",
                        width: 157,
                        height: 157,
                        fit: BoxFit.contain,
                      ),
                    ),

                    //for the instruction part
                    const SizedBox(height: 70),
                    const Text(
                      "LOGIN WITH YOUR CREDENTIALS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AutofillGroup(
                              //for Mail ID
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
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  hintText: "Email ID",
                                  hintStyle: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    //fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(Icons.mail),
                                  //hintText: "xyz@gmail.com",
                                  // labelText: "Enter Email",
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            //password part
                            TextFormField(
                              obscureText: _isObscure,
                              controller: _password,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (_password.text.length <= 3) {
                                  return "Invalid Password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey,
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  //fontSize: 20,
                                  color: Colors.black,
                                ),
                                prefixIcon: Icon(Icons.password_rounded),
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
                                //labelText: "Enter Password",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // forgot password link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 28),
                            child: InkWell(
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12.3),
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, "/forgotpass");
                              },
                            )),
                      ],
                    ),

                    //for "LOGIN" buttom (with shared Preference used)
                    const SizedBox(height: 50),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 170.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF06082E)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide()))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  buildShowDialog(context);
                                  UserCredential userCredential =
                                      await _auth.signInWithEmailAndPassword(
                                          email: _emailId.text,
                                          password: _password.text);
                                  print(userCredential);
                                  var user = FirebaseAuth.instance.currentUser!;
                                  if (user.emailVerified) {
                                    await _prefs.setString(
                                        "user_id", userCredential.user!.uid);

                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage(
                                                  companyname: '',
                                                )),
                                        (route) => false);
                                  } else {
                                    await user.sendEmailVerification();
                                    Navigator.pop(context);
                                    _showToast(context, "Verify Your Email");
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Navigator.pop(context);
                                    _showToast(context, "Email ID Not Found");
                                  } else if (e.code == 'wrong-password') {
                                    Navigator.pop(context);
                                    _showToast(context, 'Wrong password');
                                  }
                                }
                              }
                            },
                            child: const Text("LOGIN",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                          ),
                        )),

                    // for the New user registration
                    const SizedBox(height: 70),
                    const Text(
                      "New User?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),

                    // google sign-in buttom
                    /*  const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 350.0,
                          height: 45.0,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide()))),
                            onPressed: () async {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                            },
                            icon: Image.network(
                                'http://pngimg.com/uploads/google/google_PNG19635.png',
                                fit: BoxFit.cover),
                            label: const Text("Sign in with Google",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                          ),
                        )), */

                    // new register link
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(1),
                              child: InkWell(
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/NewuserReg");
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  launch(String s) {}
}

class _prefs {
  static setString(String s, String uid) {}
}

class NNavigator {
  static pushReplacementNamed(BuildContext context, String s) {}
}
