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

class CustomButtonUpload extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final bool isSelected;
  const CustomButtonUpload(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //نضعه خارح column قي listview لكي يتمدد بعرض الشاشة
        MaterialButton(
      height: 35,
      minWidth: 200,
      //هنديله radius من خلال خاصية shape
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected ? Colors.green : const Color.fromARGB(255, 71, 15, 15),
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
