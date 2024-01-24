import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  const CustomButtonAuth(
      {Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //نضعه خارح column قي listview لكي يتمدد بعرض الشاشة
        MaterialButton(
      height: 40,
      //هنديله radius من خلال خاصية shape
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color.fromARGB(255, 71, 15, 15),
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
