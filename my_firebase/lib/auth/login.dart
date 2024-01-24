import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customlogoauth.dart';
import 'package:my_firebase/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isLoading = false;

  // للتسجيل الدخول  ب google
  // نسخ الكود كما هو من https://firebase.flutter.dev/docs/auth/social
  // هنشيل <UserCredential> هنعتبرها void مبترجعش اي قيمة
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // هنضع الكود دة عشان لو مخترناش حساب google وكانت null
    // ويخرج من function ولا يسبب مشاكل ويتوقف
    if (googleUser == null) {
      return; //===================
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // شيلنا return بعد اضافة navigator
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil(
      "homepage",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   ملحوظة هامة لانكتب isLoading==true هي اصلا true
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const CustomLogoAuth(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Login To Continue Using The App ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          hinittext: "Enter Your Email",
                          myController: email,
                          validator: (val) {
                            if (val == "") {
                              return "Can't to be Empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          hinittext: "Enter Your Password",
                          myController: password,
                          validator: (val) {
                            if (val == "") {
                              return "Can't to be Empty";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              // Show a message at the top of the screen
                              Fluttertoast.showToast(
                                  msg:
                                      'برجاء ادخال البريد الالكتروني لتغيير كلمة السر',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 54, 172, 245),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // AwesomeDialog(
                              //   context: context,
                              //   dialogType: DialogType.ERROR,
                              //   animType: AnimType.RIGHSLIDE,
                              //   title: 'Error',
                              //   desc:
                              //       'برجاء ادخال البريد الالكتروني لتغيير كلمة السر',
                              // ).show();
                              return;
                            }

                            try {
                              //في حالة نسيان الباص
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              Fluttertoast.showToast(
                                  msg:
                                      'تم ارسال رسالة للبريد الالكتروني لتغيير كلمة السر',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 54, 172, 245),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg:
                                      'هذا البريد الالكتروني غير موجود الرجاء تأكد من صحته وأعد المحاولة',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 245, 54, 54),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forget Password?",
                              //لايحدث محازاة الي الجهة اليمني لانة مش container
                              // textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonAuth(
                    title: "Login",
                    onPressed: () async {
                      if (formstate.currentState!.validate()) {
                        // هنضعها من doc   https://firebase.flutter.dev/docs/auth/password-auth
                        // لتسجيل الحساب
                        try {
                          isLoading = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  // هنضع المتغير الموجود في controller ونضع بعدية text
                                  email: email.text,
                                  password: password.text);
                          isLoading = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context)
                                .pushReplacementNamed("homepage");
                          } else {
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              title: 'Error',
                              desc:
                                  'الرجاء التوجه لبريدك الالكتروني وتفعيل الحساب',
                            ).show();
                          }
                        } on FirebaseAuthException catch (e) {
                          //مهمة حتي لايستمر علامة التحميل وعدم الرجوع في
                          //حالة حدوث خطا
                          isLoading = false;
                          setState(() {});
                          print("================${e.code}");
                          if (e.code == e.code) {
                            print('No user found for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              title: 'Error',
                              desc: 'Check your Email and Password.',
                            ).show();
                          } else if (e.code == e.code) {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                            ).show();
                          }
                        }
                      } else {
                        print("not Valid");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    height: 40,
                    //هنديله radius من خلال خاصية shape
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: const Color.fromARGB(255, 4, 103, 101),
                    textColor: Colors.white,
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Login With Google"),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          "images/4.png",
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't Have An Account ? ",
                            ),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
