// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/note/addnote.dart';
import 'package:my_firebase/note/editnote.dart';

class ViewNote extends StatefulWidget {
  final String categoryId;
  const ViewNote({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  bool isLoading = true;

// لتخزين الداتا اللي هنحصل عليها من firestore
//https://firebase.flutter.dev/docs/firestore/usage
  List<QueryDocumentSnapshot> data = [];
//  لجلب الداتا
//هنضفها مباشرة في initState لاستدعائها مباشؤة عند فتح الصفحة
  getData() async {
    // هنحصل منه علي list من document الموجودة في collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note")
        .get();
    // // عشان نشوف CircularProgressIndicator
    // await Future.delayed(const Duration(seconds: 1));
    data.addAll(querySnapshot.docs);
    isLoading = false;
    //لعمل ري فريش
    setState(() {});
  }

// هيستدعي الفينكشن عند فتح الصفحة
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 71, 15, 15),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNote(docid: widget.categoryId)));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            IconButton(
                onPressed: () async {
                  // للخروج كذلك من تسجيل الحساب من google
                  // ويعطينا اختيار حساب google
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  //هنضع كود الخروج من doc https://firebase.flutter.dev/docs/auth/password-auth
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        // هنستبدل GridView بال GridView.builder عشان نمرر list
        // نضع isLoading هنا عشان يظهر
        //WillPopScope  تستخدم لتحديد الرجوع لصفحة معينة علشان ميرجعش تاني علي صفحة addnote
        //onWillPop وهتكمل في اخر الصفحة
        body: WillPopScope(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    //لازم نحدد length اللي في list من خلال data
                    itemCount: data.length,
                    //لتحديد عدد العناصر في الصف الواحد "مطلوب"
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 150.0),
                    itemBuilder: (context, i) {
                      return InkWell(
                        // عند الضغط المطول
                        onLongPress: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              animType: AnimType.RIGHSLIDE,
                              title: 'Error',
                              desc: ' هل انت متأكد من عملية الحذف ؟',
                              btnCancelOnPress: () async {},
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(widget.categoryId)
                                    .collection("note")
                                    .doc(data[i].id)
                                    .delete();
                                // علشان نمسح الصور ومتتحفظش في فايربيس وتعمل مساحة علي الفاضي
                                if (data[i]['url'] != "none") {
                                  FirebaseStorage.instance
                                      .refFromURL(data[i]['url'])
                                      .delete();
                                }

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewNote(
                                        categoryId: widget.categoryId)));
                              }).show();
                        },
                        onTap: () {
                          //لعرض الملاحظات
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                  notedocid: data[i].id,
                                  value: data[i]['note'],
                                  categorydocid: widget.categoryId)));
                        },
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                //عشان loop بنحط [i]
                                Text("${data[i]['note']}"),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (data[i]['url'] != "none")
                                  Image.network(
                                    data[i]['url'],
                                    height: 70,
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            // عند الرجوع القيمة false ويرجع لل homepage
            onWillPop: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("homepage", (route) => false);
              return Future.value(false);
            }));
  }
}
