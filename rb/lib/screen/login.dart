import 'package:firebase_core/firebase_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rb/screen/background.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final email_ = TextEditingController();
  final password_ = TextEditingController();

  Future Login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email_.text.trim(),
        password: password_.text.trim(),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'ไม่พบ User ในระบบ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    email_.dispose();
    password_.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: ResizeImage(AssetImage('assets/image/rajabopit.png'),
                        width: 250, height: 250),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "ระบบสะสมCoin",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Prompt',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "โรงเรียนวัดราชบพิธ",
                    style: TextStyle(
                        fontSize: 21, fontFamily: 'Prompt', color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 45,
                    width: 270,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 251, 22),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(2, 2),
                          )
                        ]),
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: email_,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Prompt',
                          )),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 45,
                    width: 270,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 251, 22),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(2, 2),
                          )
                        ]),
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: password_,
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: 'password',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Prompt',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: Login,
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 255, 230, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Prompt',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
