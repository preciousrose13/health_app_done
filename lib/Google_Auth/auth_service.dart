import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/Chat_App/Models/user_models.dart';
import 'package:health/View/User_Authentication/Complete_Profile_User.dart';
import 'package:health/View/Provider_Authentication/provider_complete_profile.dart';
import 'package:health/View/Provider_Pages/Provider_home/service_provider_home.dart';
import 'package:health/View/User_Pages/Home_page/home_page.dart';

class AuthServiceUserLogin {
  final UserModel userModel;
  final User? firebaseUser;
  

  AuthServiceUserLogin({required this.userModel, required this.firebaseUser});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .get();

      if (!userData.exists) {
        // User is not registered, display a Get.snackbar with an error message
        Get.snackbar(
          "Login Error",
          "This email is not registered.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return;
      }

      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);
        // Go to HomePage
        print("Log In Successful!");

        Get.to(() => HomePage(
              userModel: userModel,
              firebaseUser: userCredential.user!,
            ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}

class AuthServiceProviderLogin {
  final UserModel userModel;
  final User? firebaseUser;

  AuthServiceProviderLogin({required this.userModel, required this.firebaseUser});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .get();

      if (!userData.exists) {
        // User is not registered, display a Get.snackbar with an error message
        Get.snackbar(
          "Login Error",
          "This email is not registered.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);
        // Go to HomePage
        print("Log In Successful!");

        Get.to(() => Service_Provider_Home(
              userModel: userModel,
              firebaseUser: userCredential.user!, 
              userEmail: '',
            ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}

class AuthServiceUserRegister {
  final UserModel userModel;
  final User? firebaseUser;

  AuthServiceUserRegister({required this.userModel, required this.firebaseUser});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      String userId = googleUser!.id;
      String userEmail = googleUser.email;

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        UserModel newUser =
            UserModel(uid: userId, email: userEmail, fullname: "", profilePic: "");
        await FirebaseFirestore.instance
            .collection("Registered Users")
            .doc(uid)
            .set(newUser.tomap())
            .then((value) {
          print("New User Created!");
        });

        // Go to CompleteProfile
        print("Log In Successful!");

        Get.to(() => CompleteProfile(
              userModel: userModel,
              firebaseUser: userCredential.user!,
            ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}

class AuthServiceProviderRegister {
  final UserModel userModel;
  final User? firebaseUser;

  AuthServiceProviderRegister(
      {required this.userModel, required this.firebaseUser});

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign In process
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        UserModel newUser =
            UserModel(uid: uid, email: "", fullname: "", profilePic: "");
        await FirebaseFirestore.instance
            .collection("Registered Providers")
            .doc(uid)
            .set(newUser.tomap())
            .then((value) {
          print("New User Created!");
        });

        // Go to CompleteProfileProvider
        print("Registration Successful!");

        Get.to(() => CompleteProfileProvider(
              userModel: userModel,
              firebaseUser: userCredential.user!,
            ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}
