import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_Screeen.dart';
import 'modelclass.dart';

class new_Screen extends StatefulWidget {
  const new_Screen({super.key});

  @override
  State<new_Screen> createState() => _new_ScreenState();
}

class _new_ScreenState extends State<new_Screen> {
  List<ModelClass> userdata = [];

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user2$user1";
    } else {
      return "$user1$user2";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("hello"),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: userdata.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  String docId = chatRoomId(
                      FirebaseAuth.instance.currentUser!.email!,
                      userdata[index].email!);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Chat_Screen(
                      email: userdata[index].email!,
                      docId: docId, name: userdata[index].name!,
                    ),
                  ));
                },
                title: Text(userdata[index].email!),
              );
            },
          ),
        ));
  }

  getUserData() async {
    var data = await FirebaseFirestore.instance.collection('Rawan').get();
    print(data.docs.length);

    for (var e in data.docs) {
      setState(() {
        userdata.add(ModelClass.fromFirebase(e.data()));
      });
    }
  }
}
