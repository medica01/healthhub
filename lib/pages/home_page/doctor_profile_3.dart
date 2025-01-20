import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:health_hub/pages/home_page/all_doctor_2.dart';

class doc_profile extends StatefulWidget {
  final dynamic data;
   doc_profile({super.key, required this.data});

  @override
  State<doc_profile> createState() => _doc_profileState();
}

class _doc_profileState extends State<doc_profile> {
  bool heart =false;
  List<doctor_details> doctor_detail = [];
  bool isLoading = true;
  String? errorMessage;
  String? pk;

  @override
  void initState() {
    super.initState();
    pk= widget.data;
    _showdoctor();
  }



  Future<void> _showdoctor() async {
    final url = Uri.parse(
        "http://192.168.196.17:8000/doctor_details/doctor_editdetails/$pk/"); // Specific doctor's details
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: ListView.builder(
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

    );
  }
}
