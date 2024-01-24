import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customtextfieldadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  //      Add
// هننسخها من الموقع https://firebase.flutter.dev/docs/firestore/usage
//"الصندوق اللي بداخله الدوكمينت الاقسام"اولا هننشئ الكولكشن
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;

  addCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response = await categories.add(
            //لازم هنضع المعرف "id" عشان نعرف مين اللي اضاف القسم
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
        isLoading = false;
        // لايوجد داعي لوضع setstate هنا لان Navigator هتعمل refresh
        // setState(() {});
        //pushNamedAndRemoveUntil بتلغي كل الصفحات السابقة
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", ((route) => false));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
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
                      hinittext: "Enter name",
                      myController: name,
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
                        addCategory();
                      },
                      title: "Add")
                ],
              ),
      ),
    );
  }
}
