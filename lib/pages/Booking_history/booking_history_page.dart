import 'package:flutter/material.dart';

class booking_history_page extends StatefulWidget {
  const booking_history_page({super.key});

  @override
  State<booking_history_page> createState() => _booking_history_pageState();
}

class _booking_history_pageState extends State<booking_history_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("booking history page"),
        ),
        body: Center(
          child: Container(
            child: Text("booking history page "),
          ),
        ),
      ),
    );
  }
}
