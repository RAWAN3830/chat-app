import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat_Screen extends StatefulWidget {
  final String email;

  final String docId;
  final String name;

  const Chat_Screen(
      {super.key,
      required this.email,
      required this.docId,
      required this.name});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  TextEditingController chatController = TextEditingController();
  bool istap = false;

  String updateMessage = '';
  String dI='';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Image.network(
        'https://wallpapercave.com/wp/wp6988787.png',
        fit: BoxFit.cover,
        height: height,
        width: width,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 24,
                )),
            backgroundColor: Colors.green.shade900,
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmyoQ5HI7MXBYtxT9xBSpbUvVbcUPgpJaIOHfgP3_ahQ&s'),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Text(
                      'last seen 02:30',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              istap == true
                  ? Row(
                      children: [
                        IconButton(
                            onPressed: ()  {
                              setState(() {
                                 FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(widget.docId)
                                    .collection('chats')
                                    .doc(dI).delete();
                                 istap = !istap;
                              });



                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                chatController.text = updateMessage;
                              });
                              istap = !istap;
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ],
                    )
                  : Container()
            ],
          ),
          body: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                StreamBuilder(
                  stream: getData(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    return Container(
                      height: height-180,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: (snapshot.data!.docs[index]['send']! ==
                                    FirebaseAuth.instance.currentUser!.email!)
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  istap = !istap;

                                  updateMessage =
                                  snapshot.data!.docs[index]['msg'];
                                  dI=snapshot.data!.docs[index].id;
                                });
                              },
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 45,
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    color: Color(0xffdcf8c6),
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 30,
                                            top: 5,
                                            bottom: 20),
                                        child: Text(
                                            snapshot.data!.docs[index]['msg'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87)),
                                      ),
                                      Positioned(
                                        bottom: 4,
                                        right: 10,
                                        child: Row(
                                          children: [
                                            Text('22:00',
                                                // DateTime.now().hour.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        Colors.grey.shade600)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.done_all,
                                              color: Colors.blue,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                                  )),
                            ),
                          );
                        },
                        shrinkWrap: true,
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width,
                            child: Card(
                              margin:
                                  EdgeInsets.only(left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextFormField(
                                controller: chatController,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.emoji_emotions_outlined),
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () async {
                                        if (updateMessage == '') {
                                          await FirebaseFirestore.instance
                                              .collection('chat')
                                              .doc(widget.docId)
                                              .collection('chats')
                                              .doc()
                                              .set({
                                            'msg': chatController.text,
                                            'send': FirebaseAuth
                                                .instance.currentUser!.email!,
                                            'recives': widget.email,
                                            'createdAt':
                                                DateTime.now().toIso8601String()
                                          });
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('chat')
                                              .doc(widget.docId)
                                              .collection('chats')
                                              .doc(dI)
                                              .update(
                                                  {'msg': chatController.text});
                                        }

                                        chatController.clear();
                                        updateMessage='';
                                        dI='';
                                      }),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    ]);
  }

  getData() {
    return FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.docId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
