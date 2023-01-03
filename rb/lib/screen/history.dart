import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class history extends StatelessWidget {
  const history({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'History',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('database')
            .doc(uid)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List history = snapshot.data!['history'];
            List history_r = history.reversed.toList();

            return ListView.builder(
              itemCount: history_r.length,
              itemBuilder: ((context, index) {
                Map history_m = history_r[index];
                return ListTile(
                  title: history_m['check'] == 'add_coin'
                      ? Row(
                          children: [
                            Text('คุณได้รับ coin จาก'),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.yellow,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(2, 2),
                                    )
                                  ]),
                              child: Center(
                                child: Text(
                                  'ครู${history_m['name']}',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text('จำนวน'),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: 65,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color.fromARGB(255, 108, 252, 113),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(2, 2),
                                    )
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    width: 30,
                                    child: Text(
                                      '+${history_m['coin']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Image(
                                    image: ResizeImage(
                                        AssetImage('assets/image/rb_icon.png'),
                                        width: 20,
                                        height: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : history_m['check'] == 'sale_coin'
                          ? Row(
                              children: [
                                Text('คุณได้แลกคะแนนวิชา '),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.yellow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(2, 2),
                                        )
                                      ]),
                                  child: Center(
                                    child: Text(
                                      ' ${history_m['grade']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('จำนวน'),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  width: 65,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Color.fromARGB(255, 255, 141, 141),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(2, 2),
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Container(
                                        width: 36,
                                        child: Text(
                                          '-${history_m['coin']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Image(
                                        image: ResizeImage(
                                            AssetImage(
                                                'assets/image/rb_icon.png'),
                                            width: 20,
                                            height: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : history_m['check'] == 'vote'
                              ? Row(
                                  children: [
                                    Text('คุณได้ทำการVote Videoได้รับ'),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Container(
                                      width: 25,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.yellow,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(2, 2),
                                            )
                                          ]),
                                      child: Center(
                                        child: Image(
                                          image: ResizeImage(
                                              AssetImage(
                                                  'assets/image/rb_icon.png'),
                                              width: 20,
                                              height: 20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('จำนวน'),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      width: 65,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Color.fromARGB(
                                              255, 108, 252, 113),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(2, 2),
                                            )
                                          ]),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            width: 36,
                                            child: Center(
                                              child: Text(
                                                '+2',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Image(
                                            image: ResizeImage(
                                                AssetImage(
                                                    'assets/image/rb_icon.png'),
                                                width: 20,
                                                height: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : history_m['check'] == 'upload'
                                  ? Row(
                                      children: [
                                        Text('Videoผ่านการตรวจสอบได้รับ'),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: 25,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Colors.yellow,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(2, 2),
                                                )
                                              ]),
                                          child: Center(
                                            child: Image(
                                              image: ResizeImage(
                                                  AssetImage(
                                                      'assets/image/rb_icon.png'),
                                                  width: 20,
                                                  height: 20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('จำนวน'),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          width: 65,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Color.fromARGB(
                                                  255, 108, 252, 113),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(2, 2),
                                                )
                                              ]),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Container(
                                                width: 36,
                                                child: Center(
                                                  child: Text(
                                                    '+5',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Image(
                                                image: ResizeImage(
                                                    AssetImage(
                                                        'assets/image/rb_icon.png'),
                                                    width: 20,
                                                    height: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : history_m['check'] == 'start'
                                      ? Row(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Color.fromARGB(
                                                      255, 108, 252, 113),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(2, 2),
                                                    )
                                                  ]),
                                              child: Center(
                                                  child: Text(
                                                'เริ่มต้นใช้งาน',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ],
                                        )
                                      : Container(),
                );
              }),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
