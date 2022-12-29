import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class game extends StatelessWidget {
  const game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Rank')),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('database')
              .orderBy('coin', descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            try {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        final data = snapshot.data!.docs[index];
                        index;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            title: Row(
                              children: [
                                index == 0
                                    ? Text(
                                        '${index + 1}.'.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      )
                                    : Text('${index + 1}.'.toString()),
                                index == 0
                                    ? Icon(
                                        Icons.star,
                                        color: Color.fromARGB(255, 255, 230, 0),
                                        size: 40,
                                      )
                                    : SizedBox(
                                        width: 40,
                                      ),
                                Container(
                                    width: 180,
                                    child: Row(
                                      children: [
                                        index == 0
                                            ? Text(
                                                data['name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              )
                                            : Text(data['name']),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        index == 0
                                            ? Text(
                                                data['surname'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              )
                                            : Text(data['surname']),
                                      ],
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                index == 0
                                    ? Text(
                                        data['class'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      )
                                    : Text(data['class']),
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: ResizeImage(
                                      AssetImage('assets/image/rb_icon.png'),
                                      width: 20,
                                      height: 20),
                                ),
                                index == 0
                                    ? Text(
                                        data['coin'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      )
                                    : Text(data['coin'].toString())
                              ],
                            ),
                          ),
                        );
                      })),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 7, right: 3),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/image/rb_ban_.png'),
                            fit: BoxFit.cover),
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
                  ),
                ),
              );
            } catch (e) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
