import 'package:flutter/material.dart';

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
