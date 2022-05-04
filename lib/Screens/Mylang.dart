// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mylang extends StatefulWidget {
  const Mylang({Key? key}) : super(key: key);

  @override
  State<Mylang> createState() => _MylangState();
}

class _MylangState extends State<Mylang> {
  get floatingActionButtonLocation => null;
  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();

    /* if (prefs.getString('lang') != null) {
      Navigator.pushReplacementNamed(context, '/Login');
    } */
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> translateLang(String lang) async {
    await prefs.setString('lang', lang);
  }

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
                    const Text(
                      "CHOOSE YOUR LANGUAGE",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "भाषा चुनें",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),

                    //for "ENGLISH" buttom
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: ElevatedButton(
                          child: const Text('ENGLISH',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () async {
                            await translateLang('en');
                            Navigator.pushReplacementNamed(
                                context, "/welcomepage");
                          },
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF2F4464)),
                        ),
                      ),
                    ),

                    //for "हिन्दी" buttom
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: ElevatedButton(
                          child: const Text('हिन्दी',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () async {
                            await translateLang('hi');
                            Navigator.pushReplacementNamed(
                                context, "/welcomepage");
                          },
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF2F4464)),
                        ),
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
