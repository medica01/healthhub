import 'package:flutter/material.dart';

class location_page extends StatefulWidget {
  const location_page({super.key});

  @override
  State<location_page> createState() => _location_pageState();
}

class _location_pageState extends State<location_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("location page"),
        ),
        body: Center(
          child: Container(
            child: Text("location page "),
          ),
        ),
      ),
    );
  }
}
