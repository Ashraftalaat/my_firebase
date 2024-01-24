// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customtextfieldadd.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  //لازم نظهر الاسم القديم اللي هنعدله
  final String oldName;
  const EditCategory({
    Key? key,
    required this.docid,
    required this.oldName,
  }) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  //      Add
// هننسخها من الموقع https://firebase.flutter.dev/docs/firestore/usage
//"الصندوق اللي بداخله الدوكمينت الاقسام"اولا هننشئ الكولكشن
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;

  editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        //set = update
        //set = add
        // يعني لو doc موجود هتعدله ولو مش موجود هتضيفه
        // await categories.doc(widget.docid).update({"name": name.text});
        await categories
            .doc(widget.docid)
            .set({"name": name.text}, SetOptions(merge: true));
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

  @override
  void initState() {
    super.initState();
    //حتي لايظهر مكان الاسم فاضي ويظهر القديم
    name.text = widget.oldName;
  }

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
                        editCategory();
                      },
                      title: "Save")
                ],
              ),
      ),
    );
  }
}
