import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/auth/login.dart';
import 'package:my_firebase/auth/signup.dart';
import 'package:my_firebase/categories/addcategory.dart';
import 'package:my_firebase/firebasetools/filter.dart';
import 'package:my_firebase/firebasetools/imagepicker.dart';
import 'package:my_firebase/firebasetools/notification.dart';
import 'package:my_firebase/homepage.dart';

void main() async {
  //(1)
  //اضافة الفيربيس
  //هننسخهم من https://firebase.flutter.dev/docs/overview
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //(2)
  @override
  void initState() {
    // إظهار الاشعار في foreground حتي وهو شغال
    //مهمة جدا لانها عبارة عن stream مفتوحة علي طول
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("=====================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("===========================");
      }
    });

    // ضفناها من doc https://firebase.flutter.dev/docs/auth/start
    // لمعرفة حالة الحساب في كل ثانية هل هو مسجل ام لا
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===========================User is currently signed out!');
      } else {
        print('===========================User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 71, 15, 15),
            titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 249, 249, 249), fontSize: 20),
            iconTheme:
                IconThemeData(color: Color.fromARGB(255, 255, 255, 255))),
      ),
      // لو عامل تسجيل دخول "حسابه مش نيل"وتم التحقق من الايميل => ندخل علي الهوم وإلا ندخل علي اللوجن
      home: const TestNotification(),
      //  (FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified)
      //     ? const HomePage()
      //     : const Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) => const HomePage(),
        "addcategory": (context) => const AddCategory(),
        "filter": (context) => const FilterFirestore(),
        "imagepicker": (context) => const FilterStorage()
      },
    );
  }
}
