import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_hub/pages/home_page/all_doctor_2.dart';
import 'package:health_hub/pages/home_page/doctor_profile_3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../allfun.dart';
import 'package:http/http.dart' as http;

class doctor_details {
  int? id;
  String? doctorName;
  String? specialty;
  int? service;
  String? language;
  String? doctorImage;
  String? qualification;
  String? bio;
  int? regNo;
  String? doctorLocation;

  doctor_details(
      {this.id,
      this.doctorName,
      this.specialty,
      this.service,
      this.language,
      this.doctorImage,
      this.qualification,
      this.bio,
      this.regNo,
      this.doctorLocation});

  doctor_details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorName = json['doctor_name'];
    specialty = json['specialty'];
    service = json['service'];
    language = json['language'];
    doctorImage = json['doctor_image'];
    qualification = json['qualification'];
    bio = json['bio'];
    regNo = json['reg_no'];
    doctorLocation = json['doctor_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_name'] = this.doctorName;
    data['specialty'] = this.specialty;
    data['service'] = this.service;
    data['language'] = this.language;
    data['doctor_image'] = this.doctorImage;
    data['qualification'] = this.qualification;
    data['bio'] = this.bio;
    data['reg_no'] = this.regNo;
    data['doctor_location'] = this.doctorLocation;
    return data;
  }
}

class main_home extends StatefulWidget {
  const main_home({super.key});

  @override
  State<main_home> createState() => _main_homeState();
}

class _main_homeState extends State<main_home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home_page(),
    );
  }
}

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  bool heart =false;
  List<doctor_details> doctor_detail = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _name();
    _showdoctor();
  }



  Future<void> _showdoctor() async {
    final url = Uri.parse(
        "http://192.168.196.17:8000/doctor_details/doctor_editdetails/7/"); // Specific doctor's details
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Assuming the response is a single JSON object, not a list
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          doctor_detail = [doctor_details.fromJson(jsonResponse)];
          isLoading = false;
        });
        print(jsonResponse); // Log raw JSON response
      } else {
        setState(() {
          errorMessage = "Failed to load doctor details.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String name = "";
  String photourl = "";

  final List<String> images = [
    "https://static.vecteezy.com/system/resources/previews/016/699/936/non_2x/book-doctor-appointment-online-flat-banner-template-making-visit-poster-leaflet-printable-color-designs-editable-flyer-page-with-text-space-vector.jpg",
    "https://img.freepik.com/free-psd/medical-business-social-media-promo-template_23-2149488299.jpg?uid=R162018176&ga=GA1.1.249085122.1736660184&semt=ais_incoming",
    "https://img.freepik.com/free-psd/medical-business-horizontal-banner-template_23-2149488295.jpg?uid=R162018176&ga=GA1.1.249085122.1736660184&semt=ais_incoming"
  ];

  Future<void> _name() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("name") ?? "guest";
      photourl = pref.getString("photourl") ?? "no img";
    });
  }

  Widget a(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 22.0,

                backgroundImage: NetworkImage("$photourl"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi,Welcome,",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$name",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active_outlined,
                size: 30,
              )),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 320,
                  child: SearchBar(
                    leading: Icon(Icons.search),
                    hintText: 'Search',
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shadowColor: WidgetStatePropertyAll(Colors.grey),
                    elevation: WidgetStatePropertyAll(6.0),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                  ),
                )),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              child: CarouselSlider(
                items: images
                    .map((imagePath) => ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  clipBehavior: Clip.hardEdge,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 8.0, top: 25, bottom: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text("Categories", Colors.black, 24, FontWeight.bold),
                text("See All", Colors.grey, 20, FontWeight.bold),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  a("Dentist"),
                  a("Therapist"),
                  a("Orthodontist"),
                  a("Periodontist"),
                  a("Oral and Maxillofacial Surgeon"),
                  a("General Surgeon"),
                  a("Pediatrician"),
                  a("Ophthalmologist"),
                  a("Cardiologist"),
                  a("Physiotherapist"),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 8.0, top: 25, bottom: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text("All Doctors", Colors.black, 24, FontWeight.bold),
            GestureDetector(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>all_doctor()));
            },
                child: text("See All", Colors.grey, 20, FontWeight.bold)),
              ],
            ),
          ),
          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: doctor_detail.length,
              itemBuilder: (context, index) {
                var doctor = doctor_detail[index];
                return doctor.id != null
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(40),
                          ),

                          height: 200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                scale: 5,
                                doctor.doctorImage != null
                                    ? "http://192.168.196.17:8000${doctor.doctorImage}"
                                    : "no data ",
                                // Fallback image if null
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Dr.${doctor.doctorName ?? "unknown"}",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 48.0),
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              heart=!heart;
                                            });
                                          }, icon: Icon(
                                          heart
                                          ? FontAwesomeIcons.solidHeart
                                              : FontAwesomeIcons.heart,
                                            color: heart
                                                ? Colors.red
                                                : Colors.grey,
                                          ),),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        doctor.bio ?? "No bio",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        maxLines: 3, // Limit the text to 3 lines
                                        overflow: TextOverflow.ellipsis, // Add "..." if the text exceeds maxLines
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OutlinedButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>doc_profile(data: "${doctor.id}",)));
                                        }, child: Text("Book")),
                                        Padding(
                                          padding:  EdgeInsets.only(left: 38.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.star,color: Colors.yellow,),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 60,
                                            child: Text("${doctor.regNo ?? 0}")),
                                      ],
                                    )
                                  ],
                                ),

                              )
                            ],
                          ),
                        ),
                      )
                    : Text("data");
              }),
          Container(
            height: 300,
          )
        ],
      ),
    );
  }
}
