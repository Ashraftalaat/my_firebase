import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/categories/editcategory.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addcategory");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('HomePage'),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              //لازم نحدد length اللي في list من خلال data
              itemCount: data.length,
              //لتحديد عدد العناصر في الصف الواحد "مطلوب"
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        desc: ' اختر ماذا تريد ؟',
                        btnCancelText: "حذف",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(data[i].id)
                              .delete();
                          Navigator.of(context)
                              .pushReplacementNamed("homepage");
                        },
                        btnOkText: "تعديل",
                        btnOkOnPress: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  docid: data[i].id,
                                  oldName: data[i]['name'])));
                        }).show();
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/5.png",
                            height: 90,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //عشان loop بنحط [i]
                          Text("${data[i]['name']}")
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
