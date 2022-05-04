// ignore_for_file: unused_import

import 'package:flutter/material.dart';
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
import 'package:firebase/firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Smart Attendence System",
    home: const Mylang(),
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
      "/Home": (context) => const Homepage(
            companyname: '',
          ),
      "/welcomepage": (context) => const WelcomePage(),
      "/forgotpass": (context) => const ForgotPassword(),
      "/OTPsent": (context) => const OTPsent(),
      "/Resetpass": (context) => const ResetPassword(),
      "/Resetpass_success": (context) => const ResetPasswordSuccessfully(),
      "/NewuserReg": (context) => const NewUserRegistration(),
      "/NewAcc_Created": (context) => const NewAccountCreated(),
      "/demo": (context) => demo(),
      "/companyname": (context) => const CompanyName(),
    },
  ));
}

class Firebase {
  static initializeApp() {}
}
