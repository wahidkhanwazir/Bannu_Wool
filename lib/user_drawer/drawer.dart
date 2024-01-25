import 'dart:io';
import 'package:bannuwool/login/sign_in.dart';
import 'package:bannuwool/user_ui/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'drawer_history.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  var feedBackController = TextEditingController();
  late String deviceInfo = '';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      setState(() {
        deviceInfo =
        'Android ${androidInfo.version.sdkInt}, ${androidInfo.device}, ${androidInfo.id}';
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
      setState(() {
        deviceInfo =
        'iOS ${iosInfo.systemVersion}, ${iosInfo.name}, ${iosInfo.isPhysicalDevice}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height / 5.5,
              width: double.infinity,
              color: Colors.blue.shade100,
              child: Image.asset('assets/DirhamLogo2.png', scale: width / 30),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  height: height / 15.5,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Row(
                    children: [
                      FirebaseAuth.instance.currentUser?.email == null
                          ? Text('➣ Login here',
                          style: TextStyle(fontSize: height / 40))
                          : Text(
                        '➣ ${FirebaseAuth.instance.currentUser?.email}',
                        style: TextStyle(fontSize: height / 40),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -5,
                  child: FirebaseAuth.instance.currentUser?.email == null
                      ? IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                    icon: Icon(Icons.login,
                        size: height / 20, color: Colors.white),
                  )
                      : IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text(
                                'Are you sure you want to logout your account?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.logout,
                        size: height / 20, color: Colors.white),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.01),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: Container(
                  height: height / 14,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Row(
                    children: [
                      Text(
                        ' 1)  ',
                        style: TextStyle(fontSize: height / 40),
                      ),
                      Icon(Icons.home, size: height / 30),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: height / 40),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.01),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrawerHistory()));
                },
                child: Container(
                  height: height / 14,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Row(
                    children: [
                      Text(
                        ' 2)  ',
                        style: TextStyle(fontSize: height / 40),
                      ),
                      Icon(Icons.history, size: height / 30),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'History',
                        style: TextStyle(fontSize: height / 40),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.black, height: 10.0),
            Padding(
              padding: EdgeInsets.all(width * 0.005),
              child: Container(
                height: height / 14,
                width: double.infinity,
                color: Colors.blue.shade300,
                child: Row(
                  children: [
                    Icon(Icons.star, size: height / 30),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Contact us', style: TextStyle(fontSize: height / 35)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.01),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type a message:',
                ),
                controller: feedBackController,
                maxLines: 4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    if (FirebaseAuth.instance.currentUser?.email?.isEmpty ??
                        true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                      return;
                    } else if (feedBackController.text.isEmpty) {
                      Utils().toastMessage(
                          "No feedback shown please enter feedback");
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('feedback')
                        .add({
                      'email': FirebaseAuth.instance.currentUser?.email
                          .toString(),
                      'feedback': feedBackController.text.trim(),
                      'deviceInfo': deviceInfo.toString(),
                    });
                    Utils().toastMessage("Thanks for giving feedback");
                    feedBackController.clear();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: width * 0.005),
                    child: Container(
                      height: height / 20,
                      width: width / 4.7,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(width * 0.05),
                          bottomLeft: Radius.circular(width * 0.05),
                          bottomRight: Radius.circular(width * 0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.5,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                              color: Colors.grey),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Send',
                          style: TextStyle(
                              fontSize: width / 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
