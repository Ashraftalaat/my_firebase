import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String body;
  const Chat({Key? key, required this.body}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Container(
        child: Text(widget.body),
      ),
    );
  }
}
