import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rb/screen/file.dart';
import 'package:rb/screen/rank.dart';
import 'package:rb/screen/notification.dart';
import 'package:rb/screen/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rb/screen/teacher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:rb/data_for_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final clsss_ = TextEditingController();
  final number_ = TextEditingController();
  String name = '';
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String url) async {
      await launchUrlString(url);
    }

    Future<void> update_time_upload(int a, b, c) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user
          .doc(uid)
          .update({'accept': 0, 'upload': 0, 'day': a, 'month': b, 'year': c});
    }

    Future<void> add_remove_m_vote() {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({
        'vote1': "",
        'vote2': "",
      });
    }

    var now = DateTime.now();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('database')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (now.day != snapshot.data!['day'] ||
                now.year != snapshot.data!['year'] ||
                now.month != snapshot.data!['month']) {
              update_time_upload(now.day, now.month, now.year);
              add_remove_m_vote();
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!['role'] == 't') {
              return teacher();
            } else {
              return Scaffold(
                appBar: AppBar(
                    title: Row(
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Prompt'),
                    ),
                    SizedBox(
                      width: 167,
                    ),
                    IconButton(
                        icon: Icon(Icons.info),
                        onPressed: (() async {
                          await _launchUrl('https://youtu.be/yTG20BgVwng');
                        })),
                    SizedBox(
                      width: 25,
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return notification();
                        }));
                      },
                      icon: Icon(Icons.notifications_active),
                    ),
                  ],
                )),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Center(
                            child: Container(
                          height: 170,
                          width: 330,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.yellow,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(3, 3),
                                )
                              ]),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                            child: Container(
                              height: 145,
                              width: 145,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/image/rank_.png'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return game();
                              }));
                            },
                          ),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: 170,
                          width: 330,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.yellow,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(3, 3),
                                )
                              ]),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return file();
                              }));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  Icons.upload_file,
                                  size: 100,
                                ),
                                Text(
                                  'UploadVideo ความดี',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Prompt',
                                      color: Color.fromARGB(255, 84, 84, 84)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: 150,
                          width: 330,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.yellow,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(3, 3),
                                )
                              ]),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return profile();
                              }));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Icon(
                                  Icons.person,
                                  size: 100,
                                ),
                                Text(
                                  'ข้อมูลส่วนตัว และ แลกcoin',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Prompt',
                                      color: Color.fromARGB(255, 84, 84, 84)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.logout),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              );
            }
          } catch (e) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
