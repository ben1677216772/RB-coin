import 'dart:ffi';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Future<void> updatecoin(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'coin': a});
    }

    Future<void> update_score_math(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'math': a});
    }

    Future<void> update_score_social(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'social': a});
    }

    Future<void> update_score_computer(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'computer': a});
    }

    Future<void> update_history(Map a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({
        'history': FieldValue.arrayUnion([a])
      });
    }

    return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('database')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              try {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 230,
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            )
                          ]),
                      child: ListView(children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'ชื่อ : ${snapshot.data!['name']}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Prompt'),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'นามสกุล : ${snapshot.data!['surname']}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Prompt'),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Text(
                                'ชั้น : ${snapshot.data!['class']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                'เลขที่ : ${snapshot.data!['number']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: Row(
                            children: [
                              Image(
                                image: ResizeImage(
                                    AssetImage('assets/image/rb_icon.png'),
                                    width: 35,
                                    height: 35),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'จำนวน : ${snapshot.data!['coin']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  //คณิต
                  snapshot.data!['math'] != 5
                      ? Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                              ),
                              Text(
                                'คณิตศาสตร์ :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['math']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 87,
                                child: Center(
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Image(
                                          image: ResizeImage(
                                              AssetImage(
                                                  'assets/image/rb_icon.png'),
                                              width: 20,
                                              height: 20),
                                        ),
                                        Text(
                                          '800',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    onPressed: (() {
                                      if (snapshot.data!['coin'] >= 800) {
                                        List his_l = snapshot.data!['history'];
                                        updatecoin(
                                            snapshot.data!['coin'] - 800);
                                        update_score_math(
                                            snapshot.data!['math'] + 5);
                                        update_history({
                                          "check": "sale_coin",
                                          "grade": "math",
                                          "coin": "800",
                                          "num": snapshot.data!['history']
                                                  [his_l.length - 1]['num'] +
                                              1,
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'คุณมีcoinไม่พอที่จะแลก',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red);
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 110,
                              ),
                              Text(
                                'คณิตศาสตร์ :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['math']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  snapshot.data!['social'] != 5
                      ? Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 86,
                              ),
                              Text(
                                'สังคมศึกษา :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['social']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 87,
                                child: Center(
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Image(
                                          image: ResizeImage(
                                              AssetImage(
                                                  'assets/image/rb_icon.png'),
                                              width: 20,
                                              height: 20),
                                        ),
                                        Text(
                                          '600',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    onPressed: (() {
                                      if (snapshot.data!['coin'] >= 600) {
                                        updatecoin(
                                            snapshot.data!['coin'] - 600);
                                        update_score_social(
                                            snapshot.data!['social'] + 5);
                                        List his_l = snapshot.data!['history'];
                                        update_history({
                                          "check": "sale_coin",
                                          "grade": "social",
                                          "coin": "600",
                                          "num": snapshot.data!['history']
                                                  [his_l.length - 1]['num'] +
                                              1,
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'คุณมีcoinไม่พอที่จะแลก',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red);
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 117,
                              ),
                              Text(
                                'สังคมศึกษา :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['social']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  snapshot.data!['computer'] != 5
                      ? Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 77,
                              ),
                              Text(
                                'คอมพิวเตอร์ :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['computer']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 87,
                                child: Center(
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Image(
                                          image: ResizeImage(
                                              AssetImage(
                                                  'assets/image/rb_icon.png'),
                                              width: 20,
                                              height: 20),
                                        ),
                                        Text(
                                          '600',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    onPressed: (() {
                                      if (snapshot.data!['coin'] >= 600) {
                                        updatecoin(
                                            snapshot.data!['coin'] - 600);
                                        update_score_computer(
                                            snapshot.data!['computer'] + 5);
                                        List his_l = snapshot.data!['history'];
                                        update_history({
                                          "check": "sale_coin",
                                          "grade": "computer",
                                          "coin": "600",
                                          "num": snapshot.data!['history']
                                                  [his_l.length - 1]['num'] +
                                              1,
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'คุณมีcoinไม่พอที่จะแลก',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red);
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 108,
                              ),
                              Text(
                                'คอมพิวเตอร์ :',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${snapshot.data!['computer']}/5',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Prompt',
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                ]);
              } catch (e) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
