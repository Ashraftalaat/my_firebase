import 'package:flutter/material.dart';

class CustomTextFormAdd extends StatelessWidget {
  final String hinittext;
  final TextEditingController myController;
  final String? Function(String?)? validator;

  const CustomTextFormAdd(
      {Key? key,
      required this.hinittext,
      required this.myController,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: myController,
      decoration: InputDecoration(
        hintText: hinittext,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        //عشان نقدر نختار اللون
        filled: true,
        fillColor: const Color.fromARGB(255, 236, 236, 236),
        //لالغاء الخط اللي من تحت
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 236, 236, 236),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 236, 236, 236),
          ),
        ),
      ),
    );
  }
}
