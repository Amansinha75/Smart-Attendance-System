// ignore_for_file: file_names, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

class NewUserRegistration extends StatefulWidget {
  const NewUserRegistration({Key? key}) : super(key: key);

  @override
  State<NewUserRegistration> createState() => _NewUserRegistrationState();
}

class _NewUserRegistrationState extends State<NewUserRegistration> {
  int valueChoose = 0;
  //final List<String> listItems = ["BSPGCL", "BSPTCL", "SBPDCL", "NBPDCL"];

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

                    //for name
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
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

                    //for Employee ID part
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Employee ID",
                            prefixIcon: Icon(Icons.perm_identity)),
                      ),
                    ),

                    //for EMail part
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        
                        
                        
                        decoration:  InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            hintText: "Mail ID",
                            prefixIcon: Icon(Icons.mail)),
                      ),
                    ),

                    //for Mobile No. part
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
                            hintText: "Contact Number",
                            prefixIcon: Icon(Icons.phone_android)),
                      ),
                    ),

                    //for password part
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
                            hintText: "Create Password",
                            prefixIcon: Icon(Icons.security)),
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
                                  context, "/NewAcc_Created");
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
