import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health/Chat_App/Models/ui_helper.dart';
import 'package:health/Google_Auth/auth_service.dart';
import 'package:health/View/User_Authentication/Complete_Profile_User.dart';
import 'package:health/Chat_App/Models/user_models.dart';
import 'package:health/Resources/Button/mybutton.dart';
import 'package:health/Resources/TextField/MyTextField.dart';
import 'package:health/View/User_Authentication/user_login.dart';

class User_Register extends StatefulWidget {
  const User_Register({Key? key}) : super(key: key);

  @override
  _User_RegisterState createState() => _User_RegisterState();
}

class _User_RegisterState extends State<User_Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      print("Please fill all the fields");
    } else if (password != cPassword) {
      print("The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      // Check if the user already exists
      User? existingUser = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email)
          .then((methods) {
        return methods.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
      });

      if (existingUser != null) {
        Navigator.pop(context);

        // Display a Get.snackbar with an error message
        Get.snackbar(
          "Sign Up Error",
          "The email address is already in use by another account.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // If the user does not exist, create a new account
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);

      // Display a Get.snackbar with an error message
      Get.snackbar(
        "Sign Up Error",
        ex.message!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilePic: "");
      await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .set(newUser.tomap())
          .then((value) {
        print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CompleteProfile(
                userModel: newUser, firebaseUser: credential!.user!);
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage(
                        "assets/logo/harees_logo.png",
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: emailController,
                      obscureText: false,
                      labelText: "Email Address",
                      conditionText: "Email Address cannot be empty"),
                  MyTextField(
                      controller: passwordController,
                      obscureText: true,
                      labelText: "Password",
                      conditionText: "Password cannot be empty"),
                  MyTextField(
                      controller: cPasswordController,
                      obscureText: true,
                      labelText: "Confirm Password",
                      conditionText: "Password cannot be empty"),
                  SizedBox(height: 20),
                  RoundButton(
                      text: "Sign Up",
                      onTap: () {
                        checkValues();
                      }),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthServiceUserRegister(userModel: UserModel(), firebaseUser: FirebaseAuth.instance.currentUser).signInWithGoogle();
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            backgroundImage:
                                Image.asset("assets/images/google.png").image),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            backgroundImage:
                                Image.asset("assets/images/apple.png").image),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            backgroundImage:
                                Image.asset("assets/images/fb.png").image),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already a User?".tr,
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                "Let's Login".tr,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
