// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_import

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';


import 'logged_in.dart';

class Homepage extends StatefulWidget {
  final String companyname;

  var uID;
  Homepage({
    Key? key,
    required this.companyname,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences sharedPreferences;
  double lat = 0;
  double lon = 0;
  String result = "";
  int bottomIndex = 0;
  String uID = "";
  String _email = "";
  String _name = "";
  String _phone = "";
  String _employeeID = "";
  String _designation = "";
  //String formattedDate = formatter.format(now);

  

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  var ref;

//FOR GETTING USER DATA
  Future ini() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("user_id") != null) {
      uID = sharedPreferences.getString("user_id")!;
      print(uID);
      final ref = await FirebaseDatabase.instance.ref("Users/" + uID).once();
      ref.snapshot.children.forEach((element) {
        if (element.key.toString() == "email") {
          _email = element.value.toString();
        } else if (element.key.toString() == "name") {
          _name = element.value.toString();
        } else if (element.key.toString() == "phone") {
          _phone = element.value.toString();
        } else if (element.key.toString() == "employeeID") {
          _employeeID = element.value.toString();
        } else if (element.key.toString() == "designation") {
          _designation = element.value.toString();
        }
      });

      setState(() {});
    } else {
      print("Not Found");
    }
  }

/*Markattendancedata() async {
    try {
      final newChild = ref.push();
      final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

      await FirebaseDatabase.instance.ref("Homepage/"+newChild.key.toString()).set({
        "morningtime": _morningtime.text,
        "eveningtime": _eveningtime.text,
        "userId": widget.uID,
        
      });

      _morningtime.text = "";
      _eveningtime.text = "";
    
      
      Navigator.pop(context);
      _showToast(context, "Crop Added Successfully");
      await init();
    } catch(e) {
      Navigator.pop(context);
      _showToast(context, "Some Unknown Error Occurred");
    }

  } */

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

// FOR HOME SCREEN PART
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

  // OTHER PARTS
  @override
  Widget build(BuildContext context) {
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
              ?
              //MY ACCOUNT PART
              _email.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: displayUserInfo(context, _name, _email, _phone,
                          _employeeID, _designation))
              //DASHBOARD PART
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.yellow,
                )),

      //BOTTOM ICON PART
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomIndex,
        selectedItemColor: Colors.black,
        iconSize: 25,
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
          /*3 Dashboard

          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: "Dashboard") */
        ],
      ),

      /*DRAWER PART, LEFT SIDE
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
      ), */
    );
  }
}

init() {}

class _showToast {
  _showToast(BuildContext context, String s);
}

class _eveningtime {
  static var text;
}

class _morningtime {
  static var text;
}

Widget SignUpWidget() {
  return Container();
}

Widget LoggedInWidget() {
  return Container();
}

// FOR ACCOUNT PART (WIDGET PART)
Widget displayUserInfo(context, String name, String email, String phone,
    String employeeID, String designation) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //for the instruction part
          const SizedBox(height: 10),
          const Text(
            "ACCOUNT INFO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 250,
            decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(13)),
                color: Color.fromARGB(255, 72, 81, 103)),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                //Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.grey),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                //Mail ID
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Phone Number
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        phone,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Employee ID
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.perm_identity,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        employeeID,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                //Designation
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        designation,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Company Name: " + companyname),
                ), */
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
