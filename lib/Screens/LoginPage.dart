// ignore: file_names
// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/HomePage.dart';

class LoginPage extends StatefulWidget {
  final String companyname;
  const LoginPage({Key? key, required this.companyname}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  get floatingActionButtonLocation => null;

  //for the shared Preferences part, to be directed from login page to homepage
  late SharedPreferences sharedPreferences;
  bool loggedin = false;
  bool loaded = false;
  // ignore: prefer_final_fields, unused_field
  bool _isObscure = true;
  Future ini() async {
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
                      "LOGIN WITH YOUR EMPLOYEE ID",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    //for Employee ID
                    const SizedBox(height: 25),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: "Employee ID",
                          hintStyle: TextStyle(
                            //fontWeight: FontWeight.bold,
                            //fontSize: 20,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    //for Password part
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            //fontWeight: FontWeight.bold,
                            //fontSize: 20,
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.password_rounded),
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
                                        borderRadius: BorderRadius.circular(19),
                                        side: const BorderSide()))),
                            onPressed: () async {
                              sharedPreferences.setBool("LoggedIn", true);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            companyname: widget.companyname,
                                          )));
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

class NNavigator {
  static pushReplacementNamed(BuildContext context, String s) {}
}
