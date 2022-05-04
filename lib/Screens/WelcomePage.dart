// ignore_for_file: file_names, implementation_imports, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/src/extension.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<WelcomePage> createState() => _WelcomePageState();
}

// ignore: unused_element
class _WelcomePageState extends State<WelcomePage> {
  get floatingActionButtonLocation => null;

 

  // for langauge translation -------->
  late SharedPreferences prefs;
  String lang = 'en';

   // declare string for the statement for the translation
  String welcome = "Welcome to BSPHCL Smart Attendence System";
  String login = 'LOGIN';
  String Terms = "This App is owned by";
  String Terms2 = "Bihar State Power Holding Company Limited";

  init() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString('lang') != null) {
      lang = prefs.getString('lang')!;
    }
    buildShowDialog(context);
    welcome = await translateLang(welcome, lang);
    login = await translateLang(login, lang);
    Terms = await translateLang(Terms, lang);
    Terms2=await translateLang(Terms2, lang);

    setState(() {});
    Navigator.pop(context);
  }

// for progress indicator
  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Future<String> translateLang(String text, String to) async {
    final res = await text.translate(to: to);
    return res.toString();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
// ------ for langauge translation code end here --------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                        width: 257,
                        height: 257,
                        fit: BoxFit.contain,
                      ),
                    ),
                    //for the instruction part
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        // for the text used, here'welcome' is the string we declared
                        welcome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF293b57),
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),

                    //for "LOGIN" buttom
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 160.0,
                        height: 47.0,
                        child: ElevatedButton(
                          child: Text(
                              login, // for the text used, here 'login' is the string we declared
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17)),
                          onPressed: () async {
                            Navigator.pushReplacementNamed(
                                context, "/companyname");
                          },
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF293b57)),
                        ),
                      ),
                    ),

                    //for "TERMS OF USE" part
                    const Padding(
                      padding: EdgeInsets.all(50),
                    ),

                    //const SizedBox(height: 60),

                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        Terms,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        Terms2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
