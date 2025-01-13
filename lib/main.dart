import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'Authentication/otp_verfication/phone_otp.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(first_screen());
}

class first_screen extends StatefulWidget {
  const first_screen({super.key});

  @override
  State<first_screen> createState() => _first_screenState();
}

class _first_screenState extends State<first_screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash_screen(),
    );
  }
}

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
          () =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PhoneEntryPage())),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Image.network(
              "https://img.freepik.com/free-vector/hospital-logo-design-vector-medical-cross_53876-136743.jpg?uid=R162018176&ga=GA1.1.249085122.1736660184&semt=ais_hybrid"),

        ),
      ),
    );
  }
}

