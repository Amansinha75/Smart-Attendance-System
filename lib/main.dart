// ignore_for_file: unused_import, avoid_web_libraries_in_flutter, camel_case_types

//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendence_system/Screens/CompanyName.dart';
import 'package:smart_attendence_system/Screens/ForgotPassword.dart';
import 'package:smart_attendence_system/Screens/HomePage.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';
import 'package:smart_attendence_system/Screens/Mylang.dart';
import 'package:smart_attendence_system/Screens/NewAccountCreated.dart';
import 'package:smart_attendence_system/Screens/NewUserRegistration.dart';
import 'package:smart_attendence_system/Screens/OTPsent.dart';
import 'package:smart_attendence_system/Screens/ResetPassword.dart';
import 'package:smart_attendence_system/Screens/ResetPasswordSuccessfully.dart';
import 'package:smart_attendence_system/Screens/SplashScreen.dart';
import 'package:smart_attendence_system/Screens/WelcomePage.dart';
import 'package:smart_attendence_system/Screens/demo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_attendence_system/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const name());
}

class name extends StatelessWidget {
  const name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //create: (context) => GoogleSignInProvider(),
      create: (BuildContext context) {},
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: "Smart Attendence System",
        home: WelcomePage(),
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),

        //for navigation of pages
        routes: {
          //routes is used for page navigation
          "/SplashScreen": (context) => const splashscreen(),
          "/Mylang": (context) => const Mylang(),
          "/Login": (context) => const LoginPage(
                companyname: '',
              ),
          "/Home": (context) => Homepage(
                companyname: '',
              ),
          "/welcomepage": (context) => const WelcomePage(),
          "/forgotpass": (context) => const ForgotPassword(),
          "/OTPsent": (context) => const OTPsent(),
          "/Resetpass": (context) => const ResetPassword(),
          "/Resetpass_success": (context) => const ResetPasswordSuccessfully(),
          "/NewuserReg": (context) => const NewUserRegistration(
                name: '',
                email: '',
              ),
          "/NewAcc_Created": (context) => const NewAccountCreated(),
          "/demo": (context) => const demo(
                userId: '',
              ),
          "/companyname": (context) => const CompanyName(),

          //Widget build(BuildContext context)=>ChangeNotifierProvider()

          //create: (context) => GoogleSignInProvider(),
        },
      ),
    );
  }
}
