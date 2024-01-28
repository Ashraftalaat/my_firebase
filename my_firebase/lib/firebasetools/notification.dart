import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_firebase/firebasetools/chat.dart';

class TestNotification extends StatefulWidget {
  const TestNotification({Key? key}) : super(key: key);

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  //#############  Notification  ########
  // يوجد طريقتين لارسال الاشعارات الطريقة الاولي
  //                token
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("================================");
    print(mytoken);
  }
// هننسخ token اللي هيظهر في consol
//  " cS1U7GIlSoC7KilTyVeM0y:APA91bEyuM1TMqdOddjjGOGO7Ch-Dk9R538w-Yiws-Uyu_9bZvpLHKwkp4ZtvvqKCPAbfq6S6XQAbbZZX1c5JehallSoXKyVfGTcBMH3HEW-p74Ow8LIvC20W4gRlE0xqEzyjEr8CstB "
// في الفايربيز
// ملحوظ token هيتغير عند مسح التطبيق فيجب نسخه مرة اخري
// هيصل الاشعار علي الموبايل ولكن في حالة كان
// مقفول   او    في الخلفية   فقط

// // اعطاء Permission للوصول للاشعارات وخاصة في Ios
// // مش محتاجينه لاجهزه الاندرويد
// //  هننسخ الكود https://firebase.flutter.dev/docs/messaging/permissions
//   myrequestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       // هذه الخصائص خاصة بال " ios  &  web"
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
// // هتظهر هذه الرسالة في consol
// //User granted permission
// //يعني التطبيق مسموح له الوصول للاشعارات

  @override
  void initState() {
    //  "عند ظهور الاشعار في الخلفية"عند الضغط علي الاشعار والتفاعل معه
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //وممكن نوجه لاظهار صفحة معينة مثل الشات
      if (message.data['type'] == "chat") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Chat()));
      }
    });

    // إظهار الاشعار في foreground حتي وهو شغال
    //مهمة جدا لانها عبارة عن stream مفتوحة علي طول
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("=====================Foreground onMessage");
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        //message.data['name']لو هطبع جزء من الداتا
        print("=====================Foreground message");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${message.notification!.body}")));
      }
    });
    getToken();
    //myrequestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Container(
        child: MaterialButton(
          onPressed: () async {
            //هيرسل اشعار في حالة background لمايكون في الخلفية
            await sendMessage("hi", "how are you");
          },
          child: const Text("send message"),
        ),
      ),
    );
  }
}

// Cloud Messaging Token with Api notification
//اولا هندخل علي  https://stackoverflow.com/questions/37490629/firebase-send-notification-with-rest-api
// ثانيا هناخد اللينك ونضعه في السيندر كلاينت
//"URL:
//https://fcm.googleapis.com/fcm/send"
// هنضيف Header:
//"Content-Type": "application/json",
//"Authorization": "key=<Server_key>"
//هنحصل علي <Server_key> من الفايربيز Project settings => cloud messaging
// هنعمبل manage API in google Cloud
//وبكدة هنحصل علي <Server_key> وهيكون
//"AAAAQtEcZ5I:APA91bF5CvaOr0pcHUBnJnW23u1TlqPRL0UdFYSRcc3JA1isdbqyP-TLEqO4_dpCovtSCjQawNivoabpNdpD38xavJ04CEtBQzCGH_VhVLSvwSi9KthcIbwurpZGS8hy3qA3UCy7oC7k"
//عشان نرسل الاشعار هنحط BODY:
// {
//     "to": "هننسخ token اللي هيظهر في consol
//  " cS1U7GIlSoC7KilTyVeM0y:APA91bEyuM1TMqdOddjjGOGO7Ch-Dk9R538w-Yiws-Uyu_9bZvpLHKwkp4ZtvvqKCPAbfq6S6XQAbbZZX1c5JehallSoXKyVfGTcBMH3HEW-p74Ow8LIvC20W4gRlE0xqEzyjEr8CstB "",
//     "notification": {
//       "title": "hi",
//       "body": "welcome",
//       "mutable_content": true,
//       "sound": "Tri-tone"
//       },
//هنعمل format عشانن تتشال الاخطاء لو موجودة
// ثم----- نضغط send "post"
//وهنحول هذا Request --{} الي dart
// هننسخه بعد ذلك هنا
sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAQtEcZ5I:APA91bF5CvaOr0pcHUBnJnW23u1TlqPRL0UdFYSRcc3JA1isdbqyP-TLEqO4_dpCovtSCjQawNivoabpNdpD38xavJ04CEtBQzCGH_VhVLSvwSi9KthcIbwurpZGS8hy3qA3UCy7oC7k'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        " cS1U7GIlSoC7KilTyVeM0y:APA91bEyuM1TMqdOddjjGOGO7Ch-Dk9R538w-Yiws-Uyu_9bZvpLHKwkp4ZtvvqKCPAbfq6S6XQAbbZZX1c5JehallSoXKyVfGTcBMH3HEW-p74Ow8LIvC20W4gRlE0xqEzyjEr8CstB",
    "notification": {"title": title, "body": message},
    "data": {"id": "12", "name": "ashraf", "type": "alert", "m": "dodoo"}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
