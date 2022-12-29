import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:rb/api/firebase_api.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rb/check.dart';
import 'package:rb/check_u.dart';

class file extends StatefulWidget {
  const file({super.key});

  @override
  State<file> createState() => _fileState();
}

class _fileState extends State<file> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    check check_ = check();
    check_u checku = check_u();
    check_uuu checkuuu = check_uuu();
    var now = DateTime.now();

    String uid = FirebaseAuth.instance.currentUser!.uid;
    check_f() async {
      await FirebaseFirestore.instance
          .collection('database')
          .doc(uid)
          .get()
          .then((val) {
        if (val.data()!['video'] != '') {
          check_.check__ = 1;
        } else {
          check_.check__ = 0;
        }
      });
    }

    checkuu() async {
      await FirebaseFirestore.instance
          .collection('database')
          .doc(uid)
          .get()
          .then((val) {
        if (val.data()!['upload'] < 4) {
          checkuuu.check__uuu = val.data()!['upload'];
          checku.check__u = 0;
        } else {
          checku.check__u = 1;
        }
      });
    }

    Future<void> upload_path(String a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'video': a});
    }

    Future<void> upload_upload(int a) {
      CollectionReference user =
          FirebaseFirestore.instance.collection('database');
      return user.doc(uid).update({'upload': a});
    }

    Future uploadFile() async {
      await check_f();
      await checkuu();

      if (file == null) {
        Fluttertoast.showToast(
            msg: 'กรุณาเลือกvideoของคุณ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red);
        return null;
      }
      ;
      if (checku.check__u == 1) {
        Fluttertoast.showToast(
            msg: 'คุณuploadครบ4ครั้งแล้ว',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red);
      } else if (check_.check__ == 1) {
        Fluttertoast.showToast(
            msg: 'videoคุณยังไม่ถูก accept',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        final fileName = basename(file!.path);
        final destination = 'video/$fileName';

        task = FirebaseApi.uploadFile(destination, file!);
        setState(() {});

        if (task == null) return;
        int b = int.parse(checkuuu.check__uuu.toString());
        int z = b + 1;
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        upload_path(urlDownload.toString());
        upload_upload(z);
      }
    }

    print(now);
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(title: Text('UploadFile')),
      body: Padding(
        padding: const EdgeInsets.all(70),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_file,
              size: 200,
              color: Color.fromARGB(255, 53, 53, 53),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'เลือกvideoสั้นๆและupload',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Prompt',
                            color: Colors.red),
                      ),
                      Text(
                        'ไม่เกิน 5 วินาทีและไม่เกิน20MB.',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Prompt',
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: selectFile,
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    Icon(
                      Icons.attach_file,
                      size: 28,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Select File",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              fileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  uploadFile();
                },
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: 30),
                      Icon(
                        Icons.cloud_upload,
                        size: 28,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Upload File",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        )),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Widget show_have() => StreamBuilder(
        stream: null,
        builder: ((context, snapshot) {
          return Container(
            child: Text('ben'),
          );
        }),
      );

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
