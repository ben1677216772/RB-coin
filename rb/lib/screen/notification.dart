import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:rb/data_for_notification.dart';
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

    Future<void> add_coin_up(String u, int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(u).update({'coin': a + 5});
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
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            if (snapshot.data!['accept'] < 2) {
                                              await _launchUrl(
                                                  Data.data_l![index]['video']);

                                              await getData();
                                              setState(() {
                                                n = index + 1;
                                                b = Data.data_l!.length;
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  fontSize: 20,
                                                  msg:
                                                      'คุณได้acceptครบแล้วกรุณารอวันถัดไป',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red);
                                            }
                                          },
                                        ),
                                        Container(
                                          width: 170,
                                          child: Row(children: [
                                            Text(
                                              Data.data_l![index]['name'],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Data.data_l![index]['surname'],
                                            ),
                                          ]),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            if (snapshot.data!['accept'] >= 2) {
                                              Fluttertoast.showToast(
                                                  fontSize: 20,
                                                  msg:
                                                      'คุณได้acceptครบแล้วกรุณารอวันถัดไป',
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
                                              add_coin_up(my,
                                                  Data.data_l![index]['coin']);

                                              re_video(my);
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
                                                      'สามารถกดได้แค่videoของ ${Data.data_l![n - 1]['name']}  ${Data.data_l![n - 1]['surname']} หากต้องการเปลียนให้ดูคลิปคนใหม่',
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
                                            setState(() {
                                              b = Data.data_l!.length;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            if (snapshot.data!['accept'] >= 2) {
                                              Fluttertoast.showToast(
                                                  fontSize: 20,
                                                  msg:
                                                      'คุณได้acceptครบแล้วกรุณารอวันถัดไป',
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
