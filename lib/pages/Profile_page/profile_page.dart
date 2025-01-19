import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Authentication/otp_verfication/phone_otp.dart';
import '../../allfun.dart';
class profile_page extends StatefulWidget {
  const profile_page({super.key});

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  Future<bool> signOutFromGoogle() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove the 'login' key to clear the logged-in state
      await prefs.remove('login');
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PhoneEntryPage()),
            (route) => false,
      );

      return true;
    } catch (e) {
      print('Sign-out error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffdfdfd),
          title: text("Profile", Colors.black, 30, FontWeight.bold),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => signOutFromGoogle(),
                  icon: Icon(
                    Icons.logout,
                    color: Color(0xff1f8acc),
                    size: 30,
                  ),
                )),
          ],
        ),
        body: Center(
          child: Container(
            child: Text("profile page "),
          ),
        ),
      ),
    );
  }
}
