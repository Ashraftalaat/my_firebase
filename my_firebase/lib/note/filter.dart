import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({Key? key}) : super(key: key);

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
//  ############## realtime ############
//  Stream
  final Stream<QuerySnapshot> usersStream =
      //snapshots() ضفناها عشان تبقي realtime
      FirebaseFirestore.instance.collection('users').snapshots();

//  List<QueryDocumentSnapshot> data = [];

  // intialData() async {
  //   CollectionReference users = FirebaseFirestore.instance.collection("users");

  //   // await users.where("username", isNotEqualTo: "ashraf").get();

  //   // whereIn للبحث عن اكثر من عمر  & WhereNotIn  عكسها
  //   //  await users.where("age", whereIn: [40, 50, 60]).get();

  //   // arrayContainsAny  البحث عن اكثر من قيمة
  //   // await users.where("lang", arrayContainsAny:[ "fr","ar"]).get();

  //   //orderBy("age", descending: false) الترتيب تصاعدي & true الترتيب تنازلي
  //   // await users.orderBy("age", descending: false).get();

  //   //limit(2) ميعرضش غير 2 فقط من المراتبين تصاعدي
  //   //  await users.orderBy("age", descending: false).limit(2).get();

  //   // descending: false">="- startAt([40])يعني اعرضلي بعد مترتب تصاعدي كل الاعمار اللي بتبدأ من 40 عام فيما فوق
  //   //descending: false"<="- startAt([40])
  //   // await users.orderBy("age", descending: false).startAt([40]).get();

  //   //descending: false .endAt([40]) تحت او تساى 40 & true فوق 40
  //   //endBefore[40] اصغر من فقط ولاتساوي  40
  //   //await users.orderBy("age", descending: true).endAt([40]).get();
  //   QuerySnapshot usersdata = await users.get();
  //   usersdata.docs.forEach(
  //     (element) {
  //       data.add(element);
  //     },
  //   );
  // }

  @override
  void initState() {
    //  intialData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("stream"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //Batch write لاضافة اكثر من user في وقت واحد
      //     CollectionReference users =
      //         FirebaseFirestore.instance.collection('users');
      //     DocumentReference doc1 =
      //         FirebaseFirestore.instance.collection('users').doc("1");
      //     DocumentReference doc2 =
      //         FirebaseFirestore.instance.collection('users').doc("2");

      //     WriteBatch batch = FirebaseFirestore.instance.batch();
      //     batch.set(doc1, {
      //       "username": "pavly",
      //       "money": 120,
      //       "age": "20",
      //       "phone": "2113453"
      //     });
      //     batch.set(doc2, {
      //       "username": "talaat",
      //       "money": 500,
      //       "age": "60",
      //       "phone": "21154653"
      //     });
      //     //ولايتم التنفيذ بدون كتابة الكود التالي
      //     batch.commit();
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: Container(
        padding: const EdgeInsets.all(10),
        // StreamBuilder نفس  futureBuilder
        // الفرق انه اي تغيير في السرفير بيتم في نفس الوقت علي الشاشة
        // طالما فايربيز هتبقي <QuerySnapshot>
        child: StreamBuilder<QuerySnapshot>(
            stream: usersStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("loading....");
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      trailing: Text(
                        "${snapshot.data!.docs[index]['money']}\$",
                        style: const TextStyle(fontSize: 30),
                      ),
                      subtitle: Text(
                        " age : ${snapshot.data!.docs[index]['age']}",
                        style: const TextStyle(fontSize: 30),
                      ),
                      title: Text(
                        "${snapshot.data!.docs[index]['username']}",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }),
      ),
    );
  }
}

//  //    تطبيق transaction     https://firebase.flutter.dev/docs/firestore/usage
//                   //######## مهم جدا جدا لتحويل الاموال ##############
//                     // اولا هنحدد doc
//                     DocumentReference documentReference = FirebaseFirestore
//                         .instance
//                         .collection('users')
//                         .doc(data[i].id);

//                     // ثانيا
//                     FirebaseFirestore.instance
//                         .runTransaction((transaction) async {
//                       // قرأه اولا واحضار doc علي الشاشة قبل الكتابة
//                       DocumentSnapshot snapshot =
//                           await transaction.get(documentReference);

//                       if (snapshot.exists) {
//                         var snapshotData = snapshot.data();

//                         if (snapshotData is Map<String, dynamic>) {
//                           var money = snapshotData['money'] + 100;
//                           transaction
//                               .update(documentReference, {"money": money});
//                         }
//                       }
//                       // بعد ما العملية تتم بنجاح اعمل ريفريش للصفحة
//                     }).then((value) {
//                       Navigator.of(context)
//                           .pushNamedAndRemoveUntil("filter", (route) => false);
//                     });

//  ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, i) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil("filter", (route) => false);
//                   },
//                   child: Card(
//                     child: ListTile(
//                       trailing: Text(
//                         "${data[i]['money']}\$",
//                         style: const TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18),
//                       ),
//                       subtitle: Text("age : ${data[i]['age']}"),
//                       title: Text(
//                         data[i]['username'],
//                         style: const TextStyle(fontSize: 30),
//                       ),
//                     ),
//                   ),

//                 );

//               }),
