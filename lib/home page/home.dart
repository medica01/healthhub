import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/otp_verfication/phone_otp.dart';
import '../allfun.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name='';
  String email = '';
  String mobile = '';
  String address = '';
  String userpassword = '';
  String? photourl;

  void initState(){
    super.initState();
    _saveinfo();

  }
  Future<void> _saveinfo() async{
    SharedPreferences perf = await SharedPreferences.getInstance();
    setState(() {
      name = perf.getString("name")?? "guest";
      email = perf.getString("email") ?? "unknown";
      mobile = perf.getString("mobile") ?? "unknown";
      address = perf.getString("address") ?? "unknown";
      userpassword = perf.getString("userpassword") ?? "unknown";
      photourl = perf.getString("photourl");
    });
  }

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
    return Scaffold(
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
                  color: Color(0xfffc6111),
                  size: 30,
                ),
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("$photourl" ?? ''),
            ),
            const SizedBox(height: 20),
            Text("$name" ?? 'No Name',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("$email" ?? 'No Email'),
            Text("" ?? 'No phoneno'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                bool result = await signOutFromGoogle();
                if (result) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
