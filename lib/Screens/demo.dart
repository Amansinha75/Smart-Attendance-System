import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';
import 'package:translator/translator.dart';

class demo extends StatefulWidget {
  final String userId;
  const demo({ Key? key, required this.userId }) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  final TextEditingController _message = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final DatabaseReference ref = FirebaseDatabase.instance.ref("user_ID");
  int dash = 0;
  int languageIndex = 0;
  bool serviceEnabled = false;
  late LocationPermission permission;
  late SharedPreferences prefs;
  double lat = 0;
  double lon = 0;
  var weatherData = null;
  String _email = "";
  String _name = "";
  String _phone = "";
  String hindi = "Hindi";
  String marathi = "Marathi";
  String changeLang = "Change Language";
  String logout = "Logout";
  String profile = "Profile";
  String home = "Home";
  String sellCrops = "Sell Crops";
  String marketPrice = "Market Price";
  String nearbyMarket = "Nearby Market";
  String farmingVideo = "Farming Video";
  String advisory = "Advisory";
  String contact = "Contact Us";
  String enterMessage = "Enter Your Message";
  String enterSubject = "Enter Your Subject";
  String city = "";
  String country = "";
  String weatherType = "";

  Future<void> updateLanguage(String prevLang, String newLang) async{
    changeLang = await translateLang(changeLang, prevLang, newLang);
    logout = await translateLang(logout, prevLang, newLang);
    _name = await translateLang(_name, prevLang, newLang);
    home = await translateLang(home, prevLang, newLang);
    profile = await translateLang(profile, prevLang, newLang);
    sellCrops = await translateLang(sellCrops, prevLang, newLang);
    marketPrice = await translateLang(marketPrice, prevLang, newLang);
    nearbyMarket = await translateLang(nearbyMarket, prevLang, newLang);
    farmingVideo = await translateLang(farmingVideo, prevLang, newLang);
    advisory = await translateLang(advisory, prevLang, newLang);
    contact = await translateLang(contact, prevLang, newLang);
    enterMessage = await translateLang(enterMessage, prevLang, newLang);
    enterSubject = await translateLang(enterSubject, prevLang, newLang);
    if (weatherData != null) {
      city = await translateLang(city, prevLang, newLang);
      country = await translateLang(country, prevLang, newLang);
      weatherType = await translateLang(weatherType, prevLang, newLang);
    }
  }

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<void> getLocation() async {
    var status = await Permission.location.status;
      if (status.isDenied) {
        if (!(await Permission.location.request().isGranted)) {
          _showToast(context, "Cannot retrieve your location...Permission Denied");
          return;
        }
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        _showToast(context, "Cannot retrieve your location...Permission Denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy:  LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;

      await prefs.setDouble('lat', lat);
      await prefs.setDouble('lon', lon);
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Future<void> init() async {
    
    prefs = await SharedPreferences.getInstance();

    final ref = await FirebaseDatabase.instance.ref("Users/"+widget.userId).once();
    ref.snapshot.children.forEach((element) {
      if (element.key.toString() == "email") {
        _email = element.value.toString();
      } else if (element.key.toString() == "name") {
        _name = element.value.toString();
      } else if (element.key.toString() == "phone") {
        _phone = element.value.toString();
      }
    });

    //await updateLanguage('en', provider.whichLang);

    if (prefs.getDouble("lat") != null && prefs.getDouble("lon") != null) {
      lon = prefs.getDouble("lon")!;
      lat = prefs.getDouble("lat")!;
    } else {
      await getLocation();
    }

    

    var response;
    if (response.statusCode == 200) {
      weatherData = jsonDecode(response.body);
      city = weatherData["name"];
      country = weatherData["sys"]["country"];
      weatherType = weatherData["weather"][0]["main"].toString();
      //city = await translateLang(city, 'en', provider.whichLang);
      //country = await translateLang(country, 'en', provider.whichLang);
      //weatherType = await translateLang(weatherType, 'en', provider.whichLang);
    } else {
      _showToast(context, "Some Error Occurred");
    }
    
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<String> translateLang(String txt, String oLang, String nLang) async {
    final res = await txt.translate(from: oLang, to: nLang);
    return res.toString();
  }

  submitContactMessage() async {
    try {
      final newChild = ref.push();

      await FirebaseDatabase.instance.ref("ContactUs/"+newChild.key.toString()).set({
        "userID": widget.userId,
        "subject": _subject.text,
        "message": _message.text,
      });

      _subject.text = "";
      _message.text = "";
      
      _showToast(context, "Message Send Successfully");
    } catch(e) {
      _showToast(context, "Some Unknown Error Occurred");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    //final Lang = Provider.of<LangProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kisan Seva", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: dash==0?homeWidget(context):(dash==1?profileWidget(context):contactWidget(context)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: dash,
        onTap: (index) => setState(() {
          dash = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 25,),
            label: home,
            backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 25,),
            label: profile,
            backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_outlined, size: 25,),
            label: contact,
            backgroundColor: Colors.green
          ),
        ],
      )
    );
  }

  Widget contactWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(contact, style: TextStyle(
              fontSize: 30,
            ),),
            SizedBox(height: 20,),
            TextField(
              controller: _subject,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              maxLines: 1,
              decoration: InputDecoration(
                hoverColor: Colors.white,
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color.fromARGB(255, 121, 209, 124), width: 0.0),
                ),
                hintText: enterSubject,
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _message,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              maxLines: 20,
              decoration: InputDecoration(
                hoverColor: Colors.white,
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color.fromARGB(255, 121, 209, 124), width: 0.0),
                ),
                hintText: enterMessage,
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: 100,
              height: 42,
              child: ElevatedButton(
                onPressed: () async {
                  if (_subject.text.isNotEmpty && _message.text.isNotEmpty) {
                    buildShowDialog(context);
                    await submitContactMessage();
                    Navigator.pop(context);
                  } else if (_subject.text.isEmpty) {
                    _showToast(context, "Enter Subject");
                  } else if (_message.text.isEmpty) {
                    _showToast(context, "Enter Message");
                  } else {
                    _showToast(context, "Enter Subject And Message");
                  }
                }, 
                child: const Text("Submit"),
              ),
            )
          ]
        )
      ),
    );
  }

  Widget homeWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: weatherData!=null?Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                city+", "+country,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(height: 18,),
                              Text(
                                weatherData["main"]["temp"].toString() + "?? C",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),Text(
                                weatherType,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.green,
                            backgroundImage: NetworkImage("https://openweathermap.org/img/wn/"+weatherData["weather"][0]["icon"]+"@2x.png"),
                            child: null,
                          ),
                        ]
                      ),
                    ],
                  ),
                ):Center(child: CircularProgressIndicator(color: Colors.white,),),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Weather(lon: lon, lat: lat,)))
              },
            ),
            const SizedBox(height: 15,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.plagiarism,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      sellCrops,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SellCrops(uID: widget.userId,)),
                )
              },
            ),
            const SizedBox(height: 15,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      marketPrice,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPrice()))
              },
            ),
            const SizedBox(height: 15,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      nearbyMarket,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyMarket(lat: lat, lon: lon,)))
              },
            ),
            const SizedBox(height: 15,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_collection_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      farmingVideo,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => Video()),
                )
              },
            ),
            const SizedBox(height: 15,),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width-40,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.green
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_sharp,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      advisory,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ],
                ),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Advisory()))
              },
            ),
          ]
        ),
      ),
    );
  }

  

  Widget profileWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 210,
              decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(13)),
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/unknown.jpeg'),
                    child: null,
                  ),
                  SizedBox(height: 15,),
                  Text(
                    _name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.call, size: 25,),
                        SizedBox(width: 10,),
                        Text(
                          _phone,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 25,),
                        SizedBox(width: 10,),
                        Text(
                          _email,
                          style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 130,
              decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(13)),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.language_outlined, size: 25,),
                        SizedBox(width: 10,),
                        Text(
                          changeLang,
                          style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 24,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              decoration: languageIndex==0?BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                                border: Border.all(color: Colors.green, width: 2)
                              ):null,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("English",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => {
                              changeLanguage(0)
                            },
                          ),
                          InkWell(
                            child: Container(
                              decoration: languageIndex==1?BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                                border: Border.all(color: Colors.green, width: 2)
                              ):null,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  hindi,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => {
                              changeLanguage(1)
                            },
                          ),
                          InkWell(
                            child: Container(
                              decoration: languageIndex==2?BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                                border: Border.all(color: Colors.green, width: 2)
                              ):null,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  marathi,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => {
                              changeLanguage(2)
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: 100,
              height: 42,
              child: ElevatedButton(
                child: Text(logout),
                onPressed: () async {
                  buildShowDialog(context);
                  await prefs.remove("user_id");
                  await prefs.remove("lon");
                  await prefs.remove("lat");
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => LoginPage(companyname: '',)), 
                    (route) => false
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

changeLanguage(int i) {
}

Advisory() {
}

Video() {
}

NearbyMarket({required double lat, required double lon}) {
}

MarketPrice() {
}

SellCrops({required String uID}) {
}

Weather({required double lon,required double lat}) {
}

class LangProvider {
}