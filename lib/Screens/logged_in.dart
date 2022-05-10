import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class logged_in extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   logged_in({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Container(
        child: Column(children: [
          Text("data")
        ]),
      ),
      
                        
    );
  }
}