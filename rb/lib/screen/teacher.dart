import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rb/name_teacher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class teacher extends StatefulWidget {
  const teacher({super.key});

  @override
  State<teacher> createState() => _teacherState();
}

class _teacherState extends State<teacher> {
  final clsss_ = TextEditingController();
  final number_ = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  add_profile_name_teacher name_t = add_profile_name_teacher();

  String class_a = '';
  String number_a = '';
  Future<void> update_coin(String uid, int a) {
    CollectionReference user =
        FirebaseFirestore.instance.collection('database');
    return user.doc(uid).update({'coin': a});
  }

  Future<void> update_history(String uid, Map a) {
    CollectionReference user =
        FirebaseFirestore.instance.collection('database');
    return user.doc(uid).update({
      'history': FieldValue.arrayUnion([a])
    });
  }

  profile_teacher() async {
    await FirebaseFirestore.instance
        .collection('database')
        .doc(uid)
        .get()
        .then((val) async {
      name_t.name_teacher = val.data()!['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String url) async {
      await launchUrlString(url);
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text('ค้นหานักเรียน'),
          SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 50,
              height: 18,
              child: TextFormField(
                controller: clsss_,
                decoration: InputDecoration(hintText: 'ห้อง'),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 50,
              height: 18,
              child: TextFormField(
                controller: number_,
                decoration: InputDecoration(hintText: 'เลขที่'),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 50,
            child: ElevatedButton(
                onPressed: () async {
                  await profile_teacher();
                  setState(() {
                    class_a = clsss_.text.trim();
                    number_a = number_.text.trim();
                  });
                },
                child: Icon(
                  Icons.search,
                  size: 20,
                )),
          )
        ],
      )),
      body: class_a.length > 0 && number_a.length > 0
          ? Padding(
              padding: const EdgeInsets.only(top: 25),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('database')
                      .where('number', isEqualTo: number_a)
                      .where('class', isEqualTo: class_a)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    try {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final coin_ = TextEditingController();
                              DocumentSnapshot data =
                                  snapshot.data!.docs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.yellow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 3,
                                          offset: Offset(3, 3),
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 0),
                                          child: Container(
                                            child: Row(children: [
                                              SizedBox(
                                                width: 0,
                                                height: 40,
                                              ),
                                              Container(
                                                  width: 165,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        data['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        data['surname'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                'เลขที่ ${data['number']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image(
                                                image: ResizeImage(
                                                    AssetImage(
                                                        'assets/image/rb_icon.png'),
                                                    width: 20,
                                                    height: 20),
                                              ),
                                              Text(data['coin'].toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'math ${data['math'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 170, 255, 241),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'social ${data['social'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 182, 252, 185),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'computer ${data['computer'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 167, 174, 238),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              width: 200,
                                              height: 20,
                                              child: TextFormField(
                                                controller: coin_,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'จำนวนcoinที่ให้ไม่เกิน20coin'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                  onPressed: (() {
                                                    List his_l =
                                                        data['history'];

                                                    try {
                                                      if (int.parse(coin_.text
                                                              .trim()) <=
                                                          20) {
                                                        update_coin(
                                                            data['uid'],
                                                            data['coin'] +
                                                                int.parse(coin_
                                                                    .text
                                                                    .trim()
                                                                    .toString()));

                                                        update_history(
                                                            data['uid'], {
                                                          "check": "add_coin",
                                                          "coin": coin_.text
                                                              .trim()
                                                              .toString(),
                                                          "name": name_t
                                                              .name_teacher,
                                                          "num": data['history']
                                                                  [
                                                                  his_l.length -
                                                                      1]['num'] +
                                                              1,
                                                        });
                                                        Fluttertoast.showToast(
                                                            fontSize: 15,
                                                            msg:
                                                                'สำเร็จจำนวน${int.parse(coin_.text.trim().toString())}',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.green);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            fontSize: 15,
                                                            msg:
                                                                'ใส่จำนวนcoinไม่เกิน20coin',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.red);
                                                      }
                                                    } catch (e) {
                                                      Fluttertoast.showToast(
                                                          fontSize: 15,
                                                          msg: 'ใส่จำนวนcoin',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.red);
                                                    }
                                                  }),
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }));
                      }
                    } catch (e) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 25),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('database')
                      .where('class', isEqualTo: class_a)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    try {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final coin_ = TextEditingController();
                              DocumentSnapshot data =
                                  snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.yellow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 3,
                                          offset: Offset(3, 3),
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 0),
                                          child: Container(
                                            child: Row(children: [
                                              SizedBox(
                                                width: 0,
                                                height: 40,
                                              ),
                                              Container(
                                                  width: 185,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        data['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        data['surname'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'เลขที่ ${data['number']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Image(
                                                image: ResizeImage(
                                                    AssetImage(
                                                        'assets/image/rb_icon.png'),
                                                    width: 20,
                                                    height: 20),
                                              ),
                                              Text(data['coin'].toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'math ${data['math'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 170, 255, 241),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'social ${data['social'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 182, 252, 185),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'computer ${data['computer'].toString()}/5',
                                              style: TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 167, 174, 238),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              width: 200,
                                              height: 20,
                                              child: TextFormField(
                                                controller: coin_,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'จำนวนcoinที่ให้ไม่เกิน20coin'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                  onPressed: (() {
                                                    List his_l =
                                                        data['history'];

                                                    try {
                                                      if (int.parse(coin_.text
                                                              .trim()) <=
                                                          20) {
                                                        update_coin(
                                                            data['uid'],
                                                            data['coin'] +
                                                                int.parse(coin_
                                                                    .text
                                                                    .trim()
                                                                    .toString()));
                                                        update_history(
                                                            data['uid'], {
                                                          "check": "add_coin",
                                                          "coin": coin_.text
                                                              .trim()
                                                              .toString(),
                                                          "name": name_t
                                                              .name_teacher,
                                                          "num": data['history']
                                                                  [
                                                                  his_l.length -
                                                                      1]['num'] +
                                                              1,
                                                        });

                                                        //add
                                                        Fluttertoast.showToast(
                                                            fontSize: 15,
                                                            msg:
                                                                'สำเร็จจำนวน${int.parse(coin_.text.trim().toString())}',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.green);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            fontSize: 15,
                                                            msg:
                                                                'ใส่จำนวนcoinไม่เกิน20coin',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.red);
                                                      }
                                                    } catch (e) {
                                                      Fluttertoast.showToast(
                                                          fontSize: 15,
                                                          msg: 'ใส่จำนวนcoin',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.red);
                                                    }
                                                  }),
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }));
                      }
                    } catch (e) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            FloatingActionButton(
                child: Icon(Icons.info),
                onPressed: (() async {
                  await _launchUrl('https://youtu.be/HhO14xEfIoM');
                })),
            SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              child: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
