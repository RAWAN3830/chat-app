import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_Screen.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 24,
            )),
        backgroundColor: Color(0xFF101D24),
      ),
      backgroundColor: Color(0xFF101D24),
      body: Column(
        children: [
          Text(
            'Enter your Details ',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: TextFormField(
              style: TextStyle(color: Colors.white60),
              controller: emailController,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Email',labelStyle: TextStyle(color:Color(0xFF00AF9C),fontSize: 18 ),
                hintText: 'Enter your email',hintStyle: TextStyle(color: Colors.white38),
              ),

            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: TextFormField(
              style: TextStyle(color: Colors.white60),
              controller: passwordController,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Password',labelStyle: TextStyle(color:Color(0xFF00AF9C),fontSize: 18 ),
                hintText: 'Enter  Password',hintStyle: TextStyle(color: Colors.white38),
              ),

            ),
          ),

          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  // maximumSize: MaterialStatePropertyAll,
                  shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF00AF9C))),
              onPressed: () {
                login();
              },
              child: Text(
                " LOGIN ",
                style: TextStyle(color: Color(0xFF101D24)),
              )),

        ],
      ),
    );
  }
  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new_Screen(),));

      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => RegisterScreen()));
    }

    catch (e) {
      if (e.toString().contains('[firebase_auth/invalid-credential]')) {
        Fluttertoast.showToast(msg: 'The supplied auth credential is incorrect malformed or has expired.');
      }
      rethrow;
    }
  }

}
