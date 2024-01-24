import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        //عشان نعمل دايرة حول الصورة
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 239, 239),
            borderRadius: BorderRadius.circular(70)),
        child: Image.asset(
          "images/newyear.png",
          //width: 300,
          height: 150,
          //fit: BoxFit.fill,
        ),
      ),
    );
  }
}
