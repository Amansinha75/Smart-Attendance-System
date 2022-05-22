// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_import, unused_local_variable, must_be_immutable, unused_field

import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendence_system/Screens/CompanyName.dart';
import 'package:smart_attendence_system/Screens/LoginPage.dart';
import 'package:smart_attendence_system/google_sign_in.dart';
import 'logged_in.dart';

class AttendanceData {
  String year;
  String month;
  Map<String, dynamic> dailyReport;

  AttendanceData(
      {required this.month, required this.year, required this.dailyReport});
}

class Homepage extends StatefulWidget {
  Homepage({
    Key? key,
  }) : super(key: key);

  var uID;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences sharedPreferences;
  GoogleSignInAccount? user;
  String companyName = "";
  double lat = 0;
  double lon = 0;
  String result = "";
  int bottomIndex = 0;
  String uID = "";
  String _email = "";
  String _name = "";
  String _phone = "";
  String _image = "";
  String _employeeID = "";
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String _designation = "";
  String date = "";
  String time = "";
  List<String> haveReport = [];

  final DatabaseReference ref =
      FirebaseDatabase.instance.ref("AttendanceReport");
  late DatabaseEvent data;

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(
            label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  MarkAttendance(String duration) async {
    buildShowDialog(context);
    try {
      data = await ref.once();
      String alreadyId = "";

      final temp = data.snapshot.children.where((element) {
        bool f1 = false;
        bool f2 = false;
        bool f3 = false;
        element.children.forEach((element) {
          if (element.key.toString() == "user" &&
              element.value.toString() == _email) {
            f1 = true;
          } else if (element.key.toString() == "year" &&
              element.value.toString() == date.substring(0, 4)) {
            f2 = true;
          } else if (element.key.toString() == "month" &&
              element.value.toString() == date.substring(5, 7)) {
            f3 = true;
          }
        });
        return f1 && f2 && f3;
      }).toList();

      if (temp.isEmpty) {
        final newChild = ref.push();

        await FirebaseDatabase.instance
            .ref("AttendanceReport/" + newChild.key.toString())
            .set({
          "user": _email,
          "year": date.substring(0, 4),
          "month": date.substring(5, 7),
          "attendance": {
            date.substring(8, 10): {duration + " Time": time, duration: true}
          }
        });

        Navigator.pop(context);
        attendaceMarkedStatus(
            "Attendance Marked Successfully", duration + " Time", true);
      } else {
        alreadyId = temp[0].key!;
        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref
            .child("AttendanceReport/" +
                alreadyId +
                "/attendance/" +
                date.substring(8, 10) +
                "/" +
                duration)
            .get();
        if (snapshot.exists) {
          Navigator.pop(context);
          _showToast(context, "Attendance Already Marked");
        } else {
          await FirebaseDatabase.instance
              .ref("AttendanceReport/" +
                  alreadyId +
                  "/attendance/" +
                  date.substring(8, 10))
              .update({duration + " Time": time, duration: true});
          Navigator.pop(context);
          attendaceMarkedStatus(
              "Attendance Marked Successfully", duration + " Time", true);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      _showToast(context, "Some Unknown Error Occurred");
    }
  }

  fetchDateTime() async {
    try {
      final response = await http
          .get(Uri.parse("http://worldtimeapi.org/api/timezone/Asia/Kolkata"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["day_of_week"] == 0) {
          date = "";
          time = "";
        } else {
          String temp = data["datetime"];
          date = temp.substring(0, 10);
          time = temp.substring(11, 16);
        }
      } else {
        _showToast(context, "Some Unknown Error Occured");
      }
    } catch (e) {
      _showToast(context, "Make Sure that internet is working");
    }

    if (this.mounted) {
      setState(() {});
    }
  }

//FOR GETTING USER DATA
  Future ini() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        user = account;
      });
      if (user == null) {
        await GoogleSignInApi.logout();
        sharedPreferences.setBool("LoggedIn", false);
        Navigator.pushReplacementNamed(context, "/Login");
      }
    });
    _googleSignIn.signInSilently();

    if (sharedPreferences.getString("user_id") != null) {
      uID = sharedPreferences.getString("user_id")!;
      final ref = await FirebaseDatabase.instance.ref("Users/" + uID).once();
      ref.snapshot.children.forEach((element) {
        if (element.key.toString() == "email") {
          _email = element.value.toString();
        } else if (element.key.toString() == "name") {
          _name = element.value.toString();
        } else if (element.key.toString() == "phone") {
          _phone = element.value.toString();
        } else if (element.key.toString() == "image") {
          _image = element.value.toString();
        } else if (element.key.toString() == "employeeID") {
          _employeeID = element.value.toString();
        } else if (element.key.toString() == "designation") {
          _designation = element.value.toString();
        } else if (element.key.toString() == "companyName") {
          companyName = element.value.toString();
        }
      });

      setState(() {});
    } else {
      print("Not Found");
    }
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

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        });
  }

  void attendaceMarkedStatus(String status, String time, bool flag) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(status),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  flag ? Text('Welcome to the Office.') : SizedBox(),
                  Text(time)
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

  void outOfTime(String t1, String t2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Attendence Not Marked'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    t1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(t2)
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
                          buildShowDialog(context);
                          await fetchDateTime();
                          Navigator.pop(context);
                          if (date.isEmpty || time.isEmpty) {
                            _showToast(context, "Today is Sunday");
                          } else if (9 <= int.parse(time.substring(0, 2)) &&
                              12 >= int.parse(time.substring(0, 2))) {
                            if (12 == int.parse(time.substring(0, 2)) &&
                                int.parse(time.substring(3, 5)) > 0) {
                              outOfTime('Morning Time: 9am-12pm',
                                  "Attendance can be marked between 9 AM to 12 Noon");
                            } else {
                              buildShowDialog(context);
                              await getLocation();
                              //lattitude & Longitude of office
                              double radius = getDistanceFromLatLonInKm(
                                      lat, lon, 18.674214, 73.884303) *
                                  1000;

                              Navigator.pop(context);
                              if (radius <= 100) {
                                await MarkAttendance("Morning");
                              } else {
                                attendaceMarkedStatus("Attendance Not Marked",
                                    "You are not in the premise", false);
                              }
                            }
                          } else {
                            outOfTime('Morning Time: 9am-12pm',
                                "Attendance can be marked between 9 AM to 12 Noon");
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
                          buildShowDialog(context);
                          await fetchDateTime();
                          Navigator.pop(context);
                          if (date.isEmpty || time.isEmpty) {
                            _showToast(context, "Today is Sunday");
                          } else if (17 <= int.parse(time.substring(0, 2)) &&
                              18 >= int.parse(time.substring(0, 2))) {
                            if (18 == int.parse(time.substring(0, 2)) &&
                                int.parse(time.substring(3, 5)) > 0) {
                              outOfTime('Evening Time: 5pm-6pm',
                                  "Attendence can be marked between 5pm to 6pm");
                            } else {
                              buildShowDialog(context);
                              await getLocation();
                              double radius = getDistanceFromLatLonInKm(
                                      lat, lon, 18.674214, 73.884303) *
                                  1000;

                              Navigator.pop(context);
                              if (radius <= 100) {
                                await MarkAttendance("Evening");
                              } else {
                                attendaceMarkedStatus("Attendance Not Marked",
                                    "You are not in the premise", false);
                              }
                            }
                          } else {
                            outOfTime('Evening Time: 5pm-6pm',
                                "Attendence can be marked between 5pm to 6pm");
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

  Widget showReportWidget(AttendanceData data) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 400,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            String key = data.dailyReport.keys.elementAt(index);
            bool morning =
                (data.dailyReport[key]["Morning"] == null ? false : true);
            bool evening =
                (data.dailyReport[key]["Evening"] == null ? false : true);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 130,
                decoration: const BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(10)),
                    color: Color.fromARGB(255, 42, 52, 75)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Date: " + key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Morning Attendance " +
                            (morning
                                ? ("Marked At: " +
                                    data.dailyReport[key]["Morning Time"])
                                : "Not Marked:"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Evening Attendance " +
                            (evening
                                ? ("Marked At: " +
                                    data.dailyReport[key]["Evening Time"])
                                : "Not Marked:"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (builder, context) => SizedBox(
                height: 5,
              ),
          itemCount: data.dailyReport.length),
    );
  }

  Future<List<AttendanceData>> fetchAttendanceData() async {
    try {
      final data = await ref.once();

      final report = data.snapshot.children.where((element) {
        bool flag = false;
        element.children.forEach((element) {
          if (element.key.toString() == "user" &&
              element.value.toString() == _email) {
            flag = true;
          }
        });
        return flag;
      }).toList();

      haveReport.clear();
      List<AttendanceData> attendanceArr = [];
      String month = "";
      String year = "";
      Map<String, dynamic> tempData = {};

      for (int i = 0; i < report.length; i++) {
        final element = report[i];
        tempData.clear();
        element.children.forEach((element) {
          if (element.key.toString() == 'month') {
            month = element.value.toString();
          } else if (element.key.toString() == 'year') {
            year = element.value.toString();
          } else if (element.key.toString() == 'attendance') {
            element.children.forEach((element) {
              tempData[element.key.toString()] = element.value;
            });
          }
        });
        attendanceArr.add(
            AttendanceData(month: month, year: year, dailyReport: tempData));

        haveReport.add(month + "/" + year);
      }
      return attendanceArr;
    } catch (e) {
      _showToast(context, "Some Unknown Error Occured");
    }

    return [];
  }

  Widget dashboardWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            Text(
              "Attendance Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<AttendanceData>>(
                future: fetchAttendanceData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AttendanceData>> snapshot) {
                  if (snapshot.hasData) {
                    int dropdownValue = 0;
                    List<AttendanceData>? data = snapshot.data;
                    return StatefulBuilder(builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Column(
                        children: [
                          Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton<String>(
                                    alignment: AlignmentDirectional.topStart,
                                    borderRadius: BorderRadius.circular(10.0),
                                    itemHeight: 60,
                                    elevation: 1,
                                    hint: Text(
                                      haveReport[dropdownValue],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    items: haveReport.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: haveReport
                                            .indexOf(value)
                                            .toString(),
                                        child: new Text(
                                          value,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      dropdownValue = int.parse(_!);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          showReportWidget(data![dropdownValue])
                        ],
                      );
                    });
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Some Error Occured"));
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Loading Data...")
                        ],
                      ),
                    );
                  }
                })
          ],
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
          companyName,
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
                await GoogleSignInApi.logout();
                sharedPreferences.setBool("LoggedIn", false);
                Navigator.pushReplacementNamed(context, "/Login");
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),

      backgroundColor: Colors.white,

      body: bottomIndex == 0
          ? Home(context)
          : (bottomIndex == 2
              ?
              //MY ACCOUNT PART
              _email.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: displayUserInfo(
                        context,
                        (user!.displayName).toString(),
                        (user!.email).toString(),
                        (user!.photoUrl).toString(),
                        _phone,
                        _employeeID,
                        _designation,
                        companyName,
                      ))
              //DASHBOARD PART
              : dashboardWidget()),

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

          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: "Dashboard"),
          //2 Person
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "My Account"),
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

// FOR ACCOUNT PART (WIDGET PART)
Widget displayUserInfo(context, String name, String email, String image,
    String phone, String employeeID, String designation, String companyName) {
  var user;
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
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
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 120,
            decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
                color: Color.fromARGB(255, 42, 52, 75)),
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
                            fontSize: 19,
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
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            height: 190,
            decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
                color: Color.fromARGB(255, 42, 52, 75)),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                //phone
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
                            fontSize: 19,
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
                            fontSize: 19,
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
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                //Company Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.house,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        companyName,
                        style: TextStyle(
                            fontSize: 19,
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
