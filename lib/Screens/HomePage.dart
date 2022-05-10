// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';

import 'logged_in.dart';

class Homepage extends StatefulWidget {
  final String companyname;
  Homepage({Key? key, required this.companyname,}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences sharedPreferences;
  double lat = 0;
  double lon = 0;
  String result = "";
  int bottomIndex = 0;

  var body;

  Future ini() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

// location verification of the company for marking attendance
  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    double R = 6371; // Radius of the earth in km
    double dLat = deg2rad(lat2 - lat1); // deg2rad below
    double dLon = deg2rad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  Future<void> getLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (!(await Permission.location.request().isGranted)) {
        print("Cannot retrieve your location...Permission Denied");
        return;
      }
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      print("Cannot retrieve your location...Permission Denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
  }

  @override
  void initState() {
    super.initState();
    ini();
  }

  Widget Home(BuildContext context) {
    return Container(
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
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                ),
                //for the instruction part
                const SizedBox(height: 10),
                const Text(
                  "Mark Your Attendence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),

                //for "Morning's Time" buttom (with shared Preference used)
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 170.0,
                      height: 150.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          //sharedPreferences.setBool("LoggedIn", true);
                          // time
                          final hour = DateTime.now().hour;
                          if (9 <= hour && hour <= 12) {
                            await getLocation();
                            //lattitude & Longitude of office
                            double radius = getDistanceFromLatLonInKm(
                                    lat, lon, 18.674214, 73.884303) *
                                1000;
                            if (radius <= 100) {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Attendence Marked Successfully'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text('Welcome to the Office.'),
                                              Text("Morning Time.")
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              });
                            } else {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Attendence Not Marked'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text(
                                                  'You are not in the premise'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              });
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Attendence Not Marked'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Text(
                                            'Morning Time: 9am-12pm',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              //fontSize: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                              "Attendance can be marked between 9 AM to 12 Noon")
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        // morning time buttom (style, colour)
                        child: const Text("Morning Time",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF06082E)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(19),
                                    side: const BorderSide()))),
                      ),
                    )),

                //for Evening's Time" buttom (with shared Preference used)
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 170.0,
                      height: 150.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          //sharedPreferences.setBool("LoggedIn", true);
                          final hour = DateTime.now().hour;

                          if (18 <= hour && hour <= 20) {
                            await getLocation();
                            double radius = getDistanceFromLatLonInKm(
                                    lat, lon, 18.674214, 73.884303) *
                                1000;
                            if (radius <= 100) {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Attendence Marked Successfully'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text('See you Next day.'),
                                              Text("Evening Time.")
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              });
                            } else {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Attendence Not Marked'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text(
                                                  'You are not in the premise'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              });
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Attendance Not Marked'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Text(
                                            'Evening Time: 5pm-6pm',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              //fontSize: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                              "Attendence can be marked between 5pm to 6pm")
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text("Evening Time",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF06082E)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(19),
                                    side: const BorderSide()))),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*final User = FirebaseAuth.instance.currentUser!;
    var user;*/
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.companyname,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ), //header part
        // for "Logout" buttom, right side
        actions: [
          IconButton(
              onPressed: () async {
                sharedPreferences.setBool("LoggedIn", false);
                Navigator.pushReplacementNamed(context, "/Login");
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),

      backgroundColor: Colors.white,

      body: bottomIndex == 0
          ? Home(context)
          : (bottomIndex == 1
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    /* StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            return logged_in();
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Something went wrong!"));
                          } else {
                            return LoginPage(
                              companyname: '',
                            );
                          }
                        }),*/
                  ]),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow,
                )),
      // drawer part, left side
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          //profile view part, at top
          children: const [
            UserAccountsDrawerHeader(
              accountName: Text("Aman Sinha"),
              accountEmail: Text("ID: SBPDCL/07"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png"),
              ),
            ),

            //for features part in the drawer
            ListTile(
                leading: Icon(Icons.satellite),
                title: Text("My Location"),
                subtitle: Text("Current: Patna, Bihar"),
                trailing: Icon(Icons.map_outlined)),

            ListTile(
                leading: Icon(Icons.language_rounded),
                title: Text("Change Language"),
                subtitle: Text("Current: English"),
                trailing: Icon(Icons.arrow_drop_down)),

            ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Today's Date"),
                subtitle: Text("Date: DD/MM/YY"),
                trailing: Icon(Icons.change_circle)),

            ListTile(
              leading: Icon(Icons.compare),
              title: Text("Feedback"),
              subtitle: Text("Write us"),
              trailing: Icon(Icons.send),
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),

              //subtitle: Text("Current: Patna, Bihar"),
              //trailing: Icon(Icons.map_outlined)
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: (int index) {
          setState(() {
            bottomIndex = index;
          });
        },
        elevation: 5,
        items: [
          //1 Home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          //2 Person
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "My Account"),
          //3 Account

          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: "Dashboard")
        ],
      ),
      //edit buttom on home page
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.edit),
      // ),
    );
  }
}

Widget SignUpWidget() {
  return Container();
}

Widget LoggedInWidget() {
  return Container();
}
