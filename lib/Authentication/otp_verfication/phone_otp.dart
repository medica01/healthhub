import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneEntryPage extends StatefulWidget {
  @override
  _PhoneEntryPageState createState() => _PhoneEntryPageState();
}

class _PhoneEntryPageState extends State<PhoneEntryPage> {
  final _phoneController = TextEditingController();
  final _form =GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedCountryCode = '+91'; // Default country code
  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait mode for this page
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    // Reset orientation to allow rotation when leaving this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user data to Firestore
      await saveUserData(userCredential.user);

      return userCredential.user;
    } catch (e) {
      print('Exception -> $e');
      return null;
    }
  }
  Future<void> saveUserData(User? user) async {
    if (user != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("login", true);
      await pref.setString("uid", user.uid ?? "");
      await pref.setString("name", user.displayName ?? "");
      await pref.setString("email", user.email ?? "");
      await pref.setString("photourl", user.photoURL ?? "");

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> userData = {
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'lastLogin': DateTime.now(),
      };

      await firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
    }
  }



  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SingleChildScrollView(
        child: Container(
          height: screen.height*1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.network(
                      "https://img.freepik.com/free-vector/hospital-logo-design-vector-medical-cross_53876-136743.jpg?uid=R162018176&ga=GA1.1.249085122.1736660184&semt=ais_hybrid",
                    ),
                  ),
                  Text(
                    "All is Well",
                    style: TextStyle(
                      color: Color(0xff1f8acc),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "Sign in/ Sign up",
                      style: TextStyle(
                        color: Color(0xff1f8acc),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0, right: 18, top: 18),
                    child: TextFormField(
                      validator: (value){
                        if (value==null|| value.isEmpty){
                          return "no phone number";
                        }
                        return null;
                      },
                      style: TextStyle(color: Color(0xff1f8acc)),
                      cursorColor: Color(0xff1f8acc),
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _phoneController,

                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        focusColor: Color(0xff46c8bb),

                        contentPadding: EdgeInsets.only(left: 90),
                        counterText: "",
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(color: Color(0xff1f8acc)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.merge(
                              BorderSide(color: Color(0xff1f8acc)),
                              BorderSide.none,
                            )

                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xff46c8bb)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: () async {
                      if(_form.currentState!.validate()){
                      String phoneNumber =
                          '$_selectedCountryCode${_phoneController.text.trim()}';
                      await _auth.verifyPhoneNumber(
                        phoneNumber: phoneNumber,
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          // Auto-retrieve not applicable here
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Verification failed: ${e.message}'),
                            ),
                          );
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpPage(
                                verificationId: verificationId,
                              ),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );}
                    },
                    child: SizedBox(
                        height: 50,
                        width: 275,
                        child: Center(
                            child: Text(
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xff1f8acc)),
                                'Continue'))),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () async{
                        User? user = await signInWithGoogle();
                        if(user !=null){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        }
                      },
                      child: Container(
                        height: 51,
                        width: 330,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(FontAwesomeIcons.google,color: Colors.white,),
                            Text("Continue with Google",style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpPage extends StatefulWidget {
  final String verificationId;

  OtpPage({required this.verificationId});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOtp() async {
    String otp = _otpController.text.trim();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      // Navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              controller: _otpController,
              appContext: context,
              length: 6,
              // Number of OTP fields
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                selectedColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
