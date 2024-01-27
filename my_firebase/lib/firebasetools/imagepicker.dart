import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilterStorage extends StatefulWidget {
  const FilterStorage({Key? key}) : super(key: key);

  @override
  State<FilterStorage> createState() => _FilterStorageState();
}

class _FilterStorageState extends State<FilterStorage> {
// يجب استدعاء "io" وليس "html"
  File? file;
//وضعنا الكود من  https://pub.dev/packages/image_picker/versions/0.8.7+1
  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? imagegallery =
        await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imagecamera != null) {
      file = File(imagecamera.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Container(
          child: Column(
        children: [
          MaterialButton(
            onPressed: () async {
              await getImage();
            },
            child: Text("camera"),
          ),
          if (file != null)
            //لانها مش موجودة في assets
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                file!,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            )
        ],
      )),
    );
  }
}
