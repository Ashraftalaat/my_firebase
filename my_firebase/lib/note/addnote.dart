// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customtextfieldadd.dart';
import 'package:my_firebase/note/viewnote.dart';

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

  addNote() async {
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
            await collectionnote.add({"note": note.text});
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
                  CustomButtonAuth(
                      onPressed: () {
                        addNote();
                      },
                      title: "Add")
                ],
              ),
      ),
    );
  }
}
