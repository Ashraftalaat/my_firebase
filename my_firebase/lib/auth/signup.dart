import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_firebase/components/custombuttonauth.dart';
import 'package:my_firebase/components/customlogoauth.dart';
import 'package:my_firebase/components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isLoading = false;

// اي صفحة فيها TextEditingController لازم نعمل dispose
// حتي لايحدث تسريب للذاكرة
  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const CustomLogoAuth(),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "SignUp To Continue Using The App ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "UserName",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          hinittext: "Enter Your UserName",
                          myController: username,
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
                        // Container(
                        //   margin: const EdgeInsets.only(top: 10, bottom: 20),
                        //   alignment: Alignment.topRight,
                        //   child: const Text(
                        //     "Forget Password?",
                        //     //لايحدث محازاة الي الجهة اليمني لانة مش container
                        //     // textAlign: TextAlign.right,
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButtonAuth(
                      title: "SignUp",
                      onPressed: () async {
                        // هنضعها من doc   https://firebase.flutter.dev/docs/auth/password-auth
                        // لتسجيل الحساب
                        if (formstate.currentState!.validate()) {
                          try {
                            isLoading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              // هنضع المتغير الموجود في controller ونضع بعدية text
                              email: email.text,
                              password: password.text,
                            );
                            isLoading = false;
                            setState(() {});
                            // للتاكد من صحة البريد الالكترونى
                            // ارسال لينك تفعيل الحساب قبل الدخول للوجين
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            // هنضع الانتقال للصفحة
                            Navigator.of(context).pushReplacementNamed("login");
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              Fluttertoast.showToast(
                                  msg: 'The password provided is too weak.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 223, 56, 70),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // AwesomeDialog(
                              //   context: context,
                              //   dialogType: DialogType.ERROR,
                              //   animType: AnimType.RIGHSLIDE,
                              //   title: 'Error',
                              //   desc: 'The password provided is too weak.',
                              // ).show();
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                              Fluttertoast.showToast(
                                  msg:
                                      'The account already exists for that email.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      const Color.fromARGB(255, 223, 56, 70),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // AwesomeDialog(
                              //   context: context,
                              //   dialogType: DialogType.ERROR,
                              //   animType: AnimType.RIGHSLIDE,
                              //   title: 'Error',
                              //   desc: 'The account already exists for that email.',
                              // ).show();
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Have An Account ? ",
                            ),
                            TextSpan(
                              text: "Login",
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
