import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_01/screens/login.dart';
import 'package:firebase_flutter_01/screens/signup.dart';
import 'package:firebase_flutter_01/screens/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email;
  var password;
  bool showSpinner = false;
  final _emailController = TextEditingController();
  final _emailValidator = ValidationBuilder().email().minLength(8).build();
  final _passwordController = TextEditingController();
  final _passwordValidator = ValidationBuilder().minLength(8).build();
  final _formKey = GlobalKey<FormState>();
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          showSpinner = false;
        });
      setState(() {
        Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => SuccessScreen()),
         );
      });
      } on FirebaseAuthException catch (e) {
         if (e.code == 'user-not-found') {
      print('No user found for that email.');
  }     else if (e.code == 'wrong-password') {
         print('Wrong password provided for that user.');
  }
      }
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Center(
          child: SizedBox(
              width: 250,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        if (!isKeyboard)
                          SvgPicture.asset(
                            'images/login.svg',
                            width: 175,
                            height: 125,
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Please SignIn to Continue',
                      style: TextStyle(
                        color: Color.fromARGB(255, 193, 191, 191),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    customTextFileds(
                      iconImg: 'images/icon_email.png',
                      textEditingController: _emailController,
                      title: 'Email',
                      valid: _emailValidator,
                      onChangeValue: email,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    customTextFileds(
                      iconImg: 'images/icon_lock.png',
                      textEditingController: _passwordController,
                      title: 'password',
                      valid: _passwordValidator,
                      onChangeValue: password,
                      isObseucre: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        signIn(_emailController.text, _passwordController.text);
                      },
                      color: const Color(0xff14DAE2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minWidth: 230,
                      height: 45,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: const [
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                        )),
                        Text(
                          'OR',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.white,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SignInButton(
                      Buttons.Google,
                         onPressed: () {
                            signInWithGoogle().whenComplete(() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SuccessScreen();
                                  },
                                ),
                              );
                            });
                          },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    bottomTxt(
                        desc: "Don't Have An Account?",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        title: 'SignUp'),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff14DAE2)),
                    ),
                  ],
                )),
              )),
        )),
      ),
    );
  }
}
