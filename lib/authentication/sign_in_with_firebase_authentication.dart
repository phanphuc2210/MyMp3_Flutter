import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  //Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  //Đăng nhập thành công một đối tượng UserCredential khác null sẽ được trả về
  return FirebaseAuth.instance.signInWithCredential(credential);
}

//e.code.toUpperCase() == "EMAIL-ALREADY-IN-USE"
// Phương thức đăng ký tài khoản Email, password
Future<UserCredential> registerEmailPassword(
    {required String email, required String password}) {
  try {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseException catch (e) {
    return Future.error(e.code);
  }
}

//Phương thức hỗ đăng nhập bằng Email, password
Future<UserCredential> signWithEmailPassword(
    {required String email, required String password}) async {
  try {
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  } on FirebaseAuthException catch (e) {
    return Future.error(e.code);
  }
}
