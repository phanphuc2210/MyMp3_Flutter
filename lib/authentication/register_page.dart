import 'package:flutter/material.dart';
import 'package:my_mp3/authentication/sign_in_with_firebase_authentication.dart';
import 'package:my_mp3/helper/dialog.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtRetypePassword = TextEditingController();

  bool _isObscure = true;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.black,
      ),
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
                  'Sign Up',
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
                            hintText: "Your Email",
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
                        obscureText: _isObscure,
                        validator: (value) => validateString(value),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white38,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(top: 14.0),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white38,
                            ),
                            hintText: "Your Password",
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                            )),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _isObscure
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Confirm Password",
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
                              controller: txtRetypePassword,
                              obscureText: true,
                              validator: (value) =>
                                  validateRetypePassword(value),
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
                                  hintText: "Retype your Password",
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  )),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(
                        height: 1,
                      ),
                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                    bool? validate = formState.currentState?.validate();
                    if (validate == true) {
                      error = "";
                      showSnackBar(context, "Registering.....", 600);
                      registerEmailPassword(
                              email: txtEmail.text, password: txtPassword.text)
                          .then((value) {
                        setState(() {
                          error = "Registered successfully!";
                        });
                        Navigator.pop(context);
                        showSnackBar(context, "Registered successfully!", 3);
                      }).catchError((error) {
                        setState(() {
                          this.error = error;
                        });
                        showSnackBar(
                            context, "Registered not successfully!", 3);
                      });
                    }
                  },
                  child: Container(
                    child: const Center(
                      child: Text(
                        "Sign up",
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
                error != "" ? Text(error) : const Text("")
              ],
            ),
          ),
        )),
      ),
    );
  }

  validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Bạn chưa nhập email";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Bạn đã nhập sai định dạng";
    } else {
      return null;
    }
  }

  validateString(String? value) {
    return value == null || value.isEmpty ? "Bạn chưa nhập Password" : null;
  }

  validateRetypePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Bạn chưa nhập email";
    } else {
      return txtPassword.text != txtRetypePassword.text
          ? "Password không trùng khớp"
          : null;
    }
  }
}
