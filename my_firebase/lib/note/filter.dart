import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({Key? key}) : super(key: key);

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
  List<QueryDocumentSnapshot> data = [];

  intialData() async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot usersdata = await users.get();
    // await users.where("username", isNotEqualTo: "ashraf").get();

    // whereIn للبحث عن اكثر من عمر  & WhereNotIn  عكسها
    //  await users.where("age", whereIn: [40, 50, 60]).get();

    // arrayContainsAny  البحث عن اكثر من قيمة
    // await users.where("lang", arrayContainsAny:[ "fr","ar"]).get();

    //orderBy("age", descending: false) الترتيب تصاعدي & true الترتيب تنازلي
    // await users.orderBy("age", descending: false).get();

    //limit(2) ميعرضش غير 2 فقط من المراتبين تصاعدي
    //  await users.orderBy("age", descending: false).limit(2).get();

    // descending: false">="- startAt([40])يعني اعرضلي بعد مترتب تصاعدي كل الاعمار اللي بتبدأ من 40 عام فيما فوق
    //descending: false"<="- startAt([40])
    // await users.orderBy("age", descending: false).startAt([40]).get();

    //descending: false .endAt([40]) تحت او تساى 40 & true فوق 40
    //endBefore[40] اصغر من فقط ولاتساوي  40
    //await users.orderBy("age", descending: true).endAt([40]).get();

    usersdata.docs.forEach(
      (element) {
        data.add(element);
      },
    );
  }

  @override
  void initState() {
    intialData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filter"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  //    تطبيق transaction     https://firebase.flutter.dev/docs/firestore/usage
                  //######## مهم جدا جدا لتحويل الاموال ##############
                  onTap: () {
                    // اولا هنحدد doc
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(data[i].id);

                    // ثانيا
                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      // قرأه اولا واحضار doc علي الشاشة قبل الكتابة
                      DocumentSnapshot snapshot =
                          await transaction.get(documentReference);

                      if (snapshot.exists) {
                        var snapshotData = snapshot.data();

                        if (snapshotData is Map<String, dynamic>) {
                          var money = snapshotData['money'] + 100;
                          transaction
                              .update(documentReference, {"money": money});
                        }
                      }
                      // بعد ما العملية تتم بنجاح اعمل ريفريش للصفحة
                    }).then((value) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("filter", (route) => false);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      trailing: Text(
                        "${data[i]['money']}\$",
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      subtitle: Text("age : ${data[i]['age']}"),
                      title: Text(
                        data[i]['username'],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
