import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../allfun.dart';
import 'package:http/http.dart' as http;



class message_page extends StatefulWidget {
  const message_page({super.key});

  @override
  State<message_page> createState() => _message_pageState();
}

class _message_pageState extends State<message_page> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("message page"),
        ),
        body: Center(
          child: Container(
            child: Text("message page "),
          ),
        ),
      ),
    );
  }
}
