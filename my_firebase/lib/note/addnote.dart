// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customtextfieldadd.dart';
import 'package:my_firebase/note/viewnote.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({
    Key? key,
    required this.docid,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController note = TextEditingController();

  bool isLoading = false;

  addNote(context) async {
    //      Add
// هننسخها من الموقع https://firebase.flutter.dev/docs/firestore/usage
//"الصندوق اللي بداخله الدوكمينت الاقسام"اولا هننشئ الكولكشن
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response =
            //مش محتاجين نضيف id عشان نحن بنفس القسم
            await collectionnote.add({"note": note.text, "url": url ?? "none"});
        isLoading = false;
        // لايوجد داعي لوضع setstate هنا لان Navigator هتعمل refresh
        // setState(() {});
        //pushNamedAndRemoveUntil بتلغي كل الصفحات السابقة
        Navigator.of(context)
            //MaterialPageRoute عشان نمرر معلومات categoryid
            .push(
          MaterialPageRoute(
              builder: (context) => ViewNote(categoryId: widget.docid)),
        );
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }

  // Future<void> addUser() {
  //   // Call the user's CollectionReference to add a new user
  //   return categories
  //       .add({"name": name.text})
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

// اي صفحة فيها TextEditingController لازم نعمل dispose
// حتي لايحدث تسريب للذاكرة

  // يجب استدعاء "io" وليس "html"
  File? file;
  String? url;
//وضعنا الكود من  https://pub.dev/packages/image_picker/versions/0.8.7+1
  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    // final XFile? imagegallery =
    //     await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imagecamera != null) {
      file = File(imagecamera.path);
      //upload file
      // هنزل package path
      //هيجيب اسمه
      var imagename = basename(imagecamera.path);
      // هنرفعه وهتتخزن هنا
      var refstorage = FirebaseStorage.instance.ref("images/$imagename");
      //ارفعلي الصورة علي الاستضافة
      await refstorage.putFile(file!);
      //جيب اللينك اللي بتتخزن فيه الصورة
      url = await refstorage.getDownloadURL();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Form(
        key: formstate,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    child: CustomTextFormAdd(
                      hinittext: "Enter your note",
                      myController: note,
                      validator: (val) {
                        if (val == "") {
                          return "Can't to be Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  CustomButtonUpload(
                      onPressed: () {
                        getImage();
                      },
                      title: "Upload Image",
                      isSelected: url == null ? false : true),
                  CustomButtonAuth(
                      onPressed: () {
                        addNote(context);
                      },
                      title: "Add")
                ],
              ),
      ),
    );
  }
}
