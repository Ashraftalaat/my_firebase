import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
//  " dWg9PlGbRTOkvfDt8Oq6bF:APA91bF_ryioXUeoiE-PeNo_uKVVYBpj9bzuK84a6j3o44sFOi6tOR1D3hqWzP7dXAH-_7I123bePAsBbAVKzbT1b5twoGHJkT37XkD3yGM8kO9su93bt4kAaMbeozTs3ZsULVRQv9xZ "
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
    getToken();
    //myrequestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: MaterialButton(
          onPressed: () async {
            await sendMessage("hi", "how are you");
          },
          child: Text("send message"),
        ),
      ),
    );
  }
}

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
        " dWg9PlGbRTOkvfDt8Oq6bF:APA91bF_ryioXUeoiE-PeNo_uKVVYBpj9bzuK84a6j3o44sFOi6tOR1D3hqWzP7dXAH-_7I123bePAsBbAVKzbT1b5twoGHJkT37XkD3yGM8kO9su93bt4kAaMbeozTs3ZsULVRQv9xZ",
    "notification": {"title": title, "body": message}
  };

  var http;
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
