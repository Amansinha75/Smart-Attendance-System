// ignore_for_file: file_names, implementation_imports

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';
import 'package:translator/src/extension.dart';

class CompanyName extends StatefulWidget {
  const CompanyName({Key? key}) : super(key: key);

  @override
  State<CompanyName> createState() => _CompanyNameState();
}

class _CompanyNameState extends State<CompanyName> {

  // for langauge translation
  late SharedPreferences prefs;
  String lang = 'en';

   // declare string for the statement for the translation
  String companyname = "CHOOSE YOUR COMPANY";
  init() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString('lang') != null) {
      lang = prefs.getString('lang')!;
    }
    buildShowDialog(context);
    companyname = await translateLang(companyname, lang);
    //login = await translateLang(login, lang);

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
//

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
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        "image/BSPHCL_N.png",
                        width: 190,
                        height: 190,
                        fit: BoxFit.contain,
                      ),
                    ),
                    //for the instruction part
                    const SizedBox(height: 50),
                    Text(
                      companyname,
                      style: const 
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(height: 40),

                    //for Company buttom, upper part
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //1 BSPGCL
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage(
                                                  companyname: "BSPGCL",
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Image.asset(
                                            "image/BSPGCL logo no BG-crop.png"),
                                      ),
                                      const Text("BSPGCL",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),

                              //2 BSPTCL
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                  companyname: "BSPTCL",
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Image.asset(
                                            "image/BSPTCL logo no BG.png"),
                                      ),
                                      const Text("BSPTCL",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //3 SBPDCL
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                  companyname: "SBPDCL",
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 110,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Image.asset("image/SBPDCL.png"),
                                      ),
                                      const Text("SBPDCL",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),

                              //4 NBPDCL
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                  companyname: "NBPDCL",
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Image.asset("image/NBPDCL.png"),
                                      ),
                                      const Text("NBPDCL",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(50),
                    ),

                    //for "TERMS OF USE" part

                    const Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        "This App is owned by",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(1),
                      child: Text(
                        "Bihar State Power Holding Company Limited",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
