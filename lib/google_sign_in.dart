// ignore_for_file: non_constant_identifier_names, unused_local_variable, unused_import

//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => googleSignIn.signIn();
  static Future logout() => googleSignIn.disconnect();
}
