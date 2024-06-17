import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101D24),
      ),
      backgroundColor: Color(0xFF101D24),
      body: Column(
        children: [
          Text(
            'Welcome To Whatsapp',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 50,
          ),
          CircleAvatar(
            radius: 200,
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ButtonStyle(
                // maximumSize: MaterialStatePropertyAll,
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF00AF9C))),
              onPressed: () {

              },
              child: Text(
                "AGREE AND CONTINUE",
                style: TextStyle(color: Color(0xFF101D24)),
              ))
        ],
      ),
    );
  }
}