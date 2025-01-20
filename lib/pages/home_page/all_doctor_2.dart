import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_hub/pages/home_page/doctor_profile_3.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

class all_doctor extends StatefulWidget {
  const all_doctor({super.key});

  @override
  State<all_doctor> createState() => _all_doctorState();
}

class _all_doctorState extends State<all_doctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "All Doctor",
          style:
              TextStyle(color: Color(0xff0a8eac), fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 360,
                  child: SearchBar(
                    leading: Icon(Icons.search),
                    hintText: 'Search a Doctor',

                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    // shadowColor: WidgetStatePropertyAll(Colors.grey),
                    elevation: WidgetStatePropertyAll(6.0),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                  ),
                )),
          ),
        ),
      ),
      body: doctor_id(),
    );
  }
}

class doctor_id extends StatefulWidget {
  const doctor_id({super.key});

  @override
  State<doctor_id> createState() => _doctor_idState();
}

class _doctor_idState extends State<doctor_id> {
  bool heart = false;
  List<doctor_details> doctor_detail = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _showdoctor();
  }

  Future<void> _showdoctor() async {
    final url = Uri.parse(
        "http://192.168.196.17:8000/doctor_details/doctor_addetails/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          doctor_detail = jsonResponse
              .map((data) => doctor_details.fromJson(data))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "failed to load doctor_details";
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: doctor_detail.length,
          itemBuilder: (context, index) {
            var doctor = doctor_detail[index];
            return doctor.id != null
                ? Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Dr.${doctor.doctorName ?? "unknown"}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 48.0),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            heart = !heart;
                                          });
                                        },
                                        icon: Icon(
                                          heart
                                              ? FontAwesomeIcons.solidHeart
                                              : FontAwesomeIcons.heart,
                                          color: heart ? Colors.red : Colors.grey,
                                        ),
                                      ),
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
                                    overflow: TextOverflow
                                        .ellipsis, // Add "..." if the text exceeds maxLines
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>doc_profile(data: "${doctor.id}",)));
                                        }, child: Text("Book",style: TextStyle(color: Color(0xff0a8eac)),)),
                                    Padding(
                                      padding: EdgeInsets.only(left: 38.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
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
    );
  }
}
