import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:rb/data_for_notification.dart';
import 'package:rb/screen/file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  data Data = data();

  Future<void> getData() async {
    var data_for_add = [];
    int n = 0;
    try {
      await FirebaseFirestore.instance
          .collection('database')
          .get()
          .then((val) async {
        val.docs.forEach((element) {
          if (element.data()['video'] != "" && element.data()['uid'] != uid) {
            Map b = element.data() as Map;
            data_for_add.add(b);
          }
          Data.data_l = data_for_add;
        });
      });
    } catch (e) {
      print('wait');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int n = 0;
  int b = 0;

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String url) async {
      await launchUrlString(url);
    }

    Future<void> re_video(String s) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(s).update({'video': ""});
    }

    Future<void> add_accept(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'accept': a + 1});
    }

    Future<void> add_coin_accept(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'coin': a + 2});
    }

    Future<void> add_vote(String u, int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({'vote': a + 1});
    }

    Future<void> update_history(String u, Map a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({
        'history': FieldValue.arrayUnion([a])
      });
    }

    Future<void> add_vote_zero(String u) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({'vote': 0});
    }

    Future<void> add_coin_up(String u, int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({'coin': a + 5});
    }

    Future<void> add_vote_to_me(int u, String a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'vote${u.toString()}': a});
    }

    Future<void> add_vote_m(String u, String a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({
        'vote_m': FieldValue.arrayUnion([a])
      });
    }

    Future<void> add_remove_m_vote(String u) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({
        'vote1': "",
        'vote2': "",
      });
    }

    Future<void> add_remove_m_vote_(String u, String a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({
        'vote_m': FieldValue.arrayRemove([a]),
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'notification',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                'กดก่อนใช้งาน->',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: Icon(Icons.refresh),
                onPressed: () async {
                  await getData();
                  setState(() {
                    b = Data.data_l!.length;
                    n = 0;
                  });
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                try {
                  if (b > 0) {
                    return Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('database')
                              .doc(uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemCount: Data.data_l!.length,
                                itemBuilder: ((context, index) {
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.play_circle,
                                            color: Colors.blue,
                                            size: 33,
                                          ),
                                          onPressed: () async {
                                            await getData();
                                            if (Data.data_l![index]['vote'] ==
                                                3) {
                                              setState(() {});
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'videoได้รับการยืนยันแล้ว',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);
                                            } else if (snapshot
                                                    .data!['accept'] <
                                                2) {
                                              await _launchUrl(
                                                  Data.data_l![index]['video']);

                                              await getData();
                                              setState(() {
                                                n = index + 1;
                                                b = Data.data_l!.length;
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'คุณได้Voteครบแล้วกรุณารอวันถัดไป',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            }
                                          },
                                        ),
                                        Text(
                                          '<--กดเพื่อตรวจสอบvideo',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        Text(
                                            '${Data.data_l![index]['vote']}/3'),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            await getData();
                                            if (Data.data_l![index]['vote'] ==
                                                3) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'videoได้รับการยืนยันแล้ว',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);
                                            } else if (snapshot
                                                    .data!['accept'] >=
                                                2) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'คุณได้Voteครบแล้วกรุณารอวันถัดไป',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            } else if (snapshot
                                                        .data!['vote1'] ==
                                                    Data.data_l![index]
                                                        ['uid'] ||
                                                snapshot.data!['vote2'] ==
                                                    Data.data_l![index]
                                                        ['uid']) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg: 'กรุณาอย่าVote videoซ้ำ',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            } else if (n == (index + 1)) {
                                              add_accept(
                                                  snapshot.data!['accept']);
                                              add_coin_accept(
                                                  snapshot.data!['coin']);

                                              add_vote_to_me(
                                                  snapshot.data!['accept'] + 1,
                                                  Data.data_l![index]['uid']);
                                              add_vote(
                                                  Data.data_l![index]['uid'],
                                                  Data.data_l![index]['vote']);
                                              add_vote_m(
                                                  Data.data_l![index]['uid'],
                                                  uid);
                                              List his_l =
                                                  snapshot.data!['history'];

                                              update_history(uid, {
                                                "check": "vote",
                                                "num": snapshot.data!['history']
                                                            [his_l.length - 1]
                                                        ['num'] +
                                                    1
                                              });

                                              Fluttertoast.showToast(
                                                  msg: 'คุณได้รับ2coin',
                                                  fontSize: 20,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);

                                              setState(() {
                                                b = Data.data_l!.length;
                                                n = 0;
                                              });
                                            } else if (n > 0) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'สามารถกดยืนยันได้แค่videoที่คุณดูเท่านั้น',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: 'กรุณากดดูคลิปก่อน',
                                                  fontSize: 20,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            }
                                            await getData();
                                            if (Data.data_l![index]['vote'] ==
                                                3) {
                                              List his_l = Data.data_l![index]
                                                  ['history'];
                                              update_history(
                                                  Data.data_l![index]['uid'], {
                                                "check": "upload",
                                                "num": Data.data_l![index]
                                                                ['history']
                                                            [his_l.length - 1]
                                                        ['num'] +
                                                    1
                                              });
                                              String my = Data.data_l![index]
                                                      ['uid']
                                                  .toString();
                                              re_video(my);
                                              add_coin_up(my,
                                                  Data.data_l![index]['coin']);
                                              add_vote_zero(
                                                  Data.data_l![index]['uid']);
                                              int n_ = Data
                                                  .data_l![index]['vote_m']
                                                  .length;
                                              for (int s = 0; s < n_; s++) {
                                                String uid_m =
                                                    Data.data_l![index]
                                                        ['vote_m'][s];
                                                add_remove_m_vote(uid_m);
                                                add_remove_m_vote_(
                                                    Data.data_l![index]['uid'],
                                                    uid_m);
                                              }
                                              await getData();
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'videoได้รับการยืนยันแล้ว',
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);
                                            }

                                            setState(() {
                                              b = Data.data_l!.length;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            await getData();
                                            if (Data.data_l![index]['vote'] ==
                                                3) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'videoได้รับการยืนยันแล้ว',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);
                                            } else if (snapshot
                                                    .data!['accept'] >=
                                                2) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'คุณได้Voteครบแล้วกรุณารอวันถัดไป',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            } else if (n == (index + 1)) {
                                              add_accept(
                                                  snapshot.data!['accept']);
                                              add_coin_accept(
                                                  snapshot.data!['coin']);
                                              String my = Data.data_l![index]
                                                      ['uid']
                                                  .toString();
                                              add_vote_to_me(
                                                  snapshot.data!['accept'] + 1,
                                                  Data.data_l![index]['uid']);
                                              add_vote_zero(
                                                  Data.data_l![index]['uid']);
                                              re_video(my);
                                              Fluttertoast.showToast(
                                                  msg: 'สำเร็จ',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.green);
                                              setState(() {
                                                b = Data.data_l!.length;
                                                n = 0;
                                              });
                                            } else if (n > 0) {
                                              Fluttertoast.showToast(
                                                  fontSize: 15,
                                                  msg:
                                                      'สามารถกดได้แค่videoของ ${Data.data_l![n - 1]['name']}  ${Data.data_l![n - 1]['surname']} หากต้องการเปลียนให้ดูคลิปคนใหม่',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            } else {
                                              Fluttertoast.showToast(
                                                  fontSize: 20,
                                                  msg: 'กรุณากดดูคลิปก่อน',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            }
                                            await getData();
                                            setState(() {
                                              b = Data.data_l!.length;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }));
                          }),
                    );
                  }
                } catch (e) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}
