import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_Screen.dart';
import 'login_screen.dart';

class Registration_Screen extends StatefulWidget {
  const Registration_Screen({super.key});

  @override
  State<Registration_Screen> createState() => _Registration_ScreenState();
}

class _Registration_ScreenState extends State<Registration_Screen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();


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
              controller: nameController,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Name',labelStyle: TextStyle(color:Color(0xFF00AF9C),fontSize: 18 ),
                hintText: 'Enter  Name',hintStyle: TextStyle(color: Colors.white38),
              ),

            ),
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
                registration();
              },
              child: Text(
                " REGISTER ",
                style: TextStyle(color: Color(0xFF101D24)),
              )),
          SizedBox(height: 20,),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  loginWithGoogle();
                },
                child: Container(
                   height: 40,
                  width: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle,image: DecorationImage(image: AssetImage('assets/images/google.png',)),color: Colors.white),
                ),
              ),

              Text('OR',
                style: TextStyle(color: Colors.white38),),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login_page(),));
                },
                child: Text('Login',
                  style: TextStyle(color: Colors.blue,fontSize: 15),),
              ),
            ],
          ),
          // SizedBox(height: 20,),

          SizedBox(height: 200,),
          Text('From',
            style: TextStyle(color: Colors.white38),),

          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(shape: BoxShape.circle,image: DecorationImage(image: AssetImage('assets/images/meta.png',)),color: Colors.transparent),
          ),

        ],
      ),
    );
  }
  registration() async {
    try {
      UserCredential? user =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await FirebaseFirestore.instance.collection('Rawan').doc().set({
        'name':nameController.text,
        'email':user.user!.email,
        'uid':user.user!.uid,
        'password': passwordController.text});

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new_Screen(),));
    } catch (e) {
      if (e.toString().contains('[firebase_auth/invalid-email]')) {
        Fluttertoast.showToast(msg: 'The email address is badly formatted.');
      }
      else if(e.toString().contains('[firebase_auth/weak-password]'))
        Fluttertoast.showToast(msg: 'Password should be at least 6 characters');

      else if(e.toString().contains('[firebase_auth/email-already-in-use]'))
        Fluttertoast.showToast(msg: 'The email address is already in use by another account.');
      rethrow;
    }
  }

  loginWithGoogle() async {
    try{
      GoogleSignIn google = GoogleSignIn();
      var user = await google.signIn();

      final GoogleSignInAuthentication? googleAuth = await user?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print(user!.displayName);
      print(user!.email);
      print(user!.photoUrl);

      await FirebaseFirestore.instance.collection('Users').doc().set({
        'uid': user.id,
        'email':user.email,
        'name':user.displayName,
        'password':'123456',
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => new_Screen(),));
    }
    catch(e){
      rethrow;
    }
    }
}
