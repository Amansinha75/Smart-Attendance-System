// ignore: file_names
import 'package:flutter/material.dart';

class NewAccountCreated extends StatefulWidget {
  const NewAccountCreated({Key? key}) : super(key: key);

  @override
  State<NewAccountCreated> createState() => _NewAccountCreatedState();
}

class _NewAccountCreatedState extends State<NewAccountCreated> {
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
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        "image/Tick_Mark_Dark-512.png",
                        width: 157,
                        height: 157,
                        fit: BoxFit.contain,
                      ),
                    ),
                    //for the instruction part
                    const SizedBox(height: 10),
                    const Text(
                      "New Account Created",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 70),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Welcome to the Smart E-attendence System",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Please Login to go to Dashboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
                              Navigator.pushReplacementNamed(context, "/Login")
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
