import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/authentication/register_page.dart';
import 'package:my_mp3/authentication/sign_in_with_firebase_authentication.dart';
import 'package:my_mp3/helper/dialog.dart';
import 'package:my_mp3/page_home.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 22.0, right: 22.0),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
            child: Form(
          key: formState,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                  'Sign In',
                  style: const TextStyle(
                      fontSize: 40.0, fontWeight: FontWeight.bold),
                  gradientType: GradientType.linear,
                  gradientDirection: GradientDirection.ttb,
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade900,
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 51, 60, 64),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 50.0,
                      child: TextFormField(
                        controller: txtEmail,
                        validator: (value) => validateEmail(value),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white38,
                            ),
                            hintText: "Enter your Email",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                            )),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 51, 60, 64),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 50.0,
                      child: TextFormField(
                        controller: txtPassword,
                        obscureText: true,
                        validator: (value) => validateString(value),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white38,
                            ),
                            hintText: "Enter your Password",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                            )),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                    if (txtEmail.text != "" && txtPassword.text != "") {
                      error = "";
                      showSnackBar(context, "Signing in.....", 300);
                      signWithEmailPassword(
                              email: txtEmail.text, password: txtPassword.text)
                          .then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false);
                        showSnackBar(
                            context,
                            "Hello ${FirebaseAuth.instance.currentUser?.email ?? ""}",
                            5);
                      }).catchError((error) {
                        setState(() {
                          this.error = error;
                        });
                        showSnackBar(context, "Sign in not successfully", 3);
                      });
                    }
                  },
                  child: Container(
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade900,
                          ]),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 50,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    showSnackBar(context, "Signing in..... ", 300);
                    var user = await signWithGoogle();
                    if (user != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false);
                      showSnackBar(
                          context,
                          "Hello ${FirebaseAuth.instance.currentUser?.email ?? ""}",
                          5);
                    } else {
                      setState(() {
                        error = "Login fails";
                      });
                      showSnackBar(context, "Sign in not successfully", 3);
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/images/logoG.png",
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          const Text(
                            "Sign in with Google",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    height: 50,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                      },
                      child: GradientText(
                        'Sign up',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ttb,
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade900,
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                error != "" ? Text(error) : const Text("")
              ],
            ),
          ),
        )),
      ),
    );
  }

  validateString(String? value) {
    return value == null || value.isEmpty ? "Bạn chưa nhập Password" : null;
  }

  validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Bạn chưa nhập email";
    } else if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Bạn đã nhập sai định dạng";
    } else {
      return null;
    }
  }
}
