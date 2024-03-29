import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet/controller/model/users_model.dart';
import '../components/colors.dart';
import '../components/common_methos.dart';
import '../pages/login_screen.dart';
import '../pages/main_home_page.dart';
import 'model/user_repository.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRepo = Get.put(UserRepository());


  Future<void> updatePasswordInFirestore(String email, String newPassword) async {
    try {
      // Get the reference to the user document in Firestore
      var userDoc = FirebaseFirestore.instance.collection('users').doc(email);

      // Update the password field in Firestore
      await userDoc.update({'password': newPassword});

      print('Password updated in Firestore for $email');
    } catch (e) {
      print('Error updating password in Firestore: $e');
    }
  }

  Future<void> passwordReset(String email) async {
    try {
      // Reset password using Firebase Authentication
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Call the function to update the password in Firestore
      await updatePasswordInFirestore(email, 'new_password');

      // Show success dialog or navigate to appropriate screen
      // ...

    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions
      print(e);

      // Show error dialog or handle the error as needed
      // ...
    }
  }
  Future clearForm() async {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    passwordController.clear();
  }

  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    try {
      // Ensure all required fields are not empty
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          phoneController.text.trim().isEmpty) {
        throw 'Please fill in all fields';
      }

      // Ensure passwords match
      if (passwordController.text != confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      // Create user with email and password
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Get the user object from the userCredential
      User user = userCredential.user!;

      // Send email verification
      await user.sendEmailVerification();

      // Save user details to Firestore
      await saveUserDetails(UserModel(
        id: user.uid,
        imageUrl: null,
        email: user.email!,
        password: passwordController.text,
        name: nameController.text.trim(),
        phone: phoneController.text.trim()
      ));

      // Show success message
      await CommonMethod().getXSnackBar(
        "Success",
        'Verification email sent to ${user.email}',
        Colors.green,
      );

      // Navigate to login screen after registration
      Get.to(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      // Handle specific error cases
      if (e.code == 'email-already-in-use') {
        await CommonMethod().getXSnackBar(
          "Error",
          'The email address is already in use. Please use a different email.',
          Colors.red,
        );
      } else if (e.code == 'weak-password') {
        await CommonMethod().getXSnackBar(
          "Error",
          'The password provided is too weak. Please choose a stronger password.',
          Colors.red,
        );
      } else {
        // Handle other authentication errors
        await CommonMethod().getXSnackBar(
          "Error",
          'Failed to register: ${e.message}',
          Colors.red,
        );
      }
    } catch (e) {
      // Handle other unexpected errors
      await CommonMethod().getXSnackBar(
        "Error",
        'Failed to register: $e',
        Colors.red,
      );
    }
  }
  Future saveUserDetails(UserModel user) async {
    userRepo.createUser(user.id!,user);
    // controller.registerWithEmailAndPassword(context);
  }



// Define a method to refresh the user
  Future<void> refreshUser() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reload the user to fetch the latest information
        await user.reload();

        // Update the user object if necessary
        user = FirebaseAuth.instance.currentUser;

        // Optionally, perform any actions after refreshing the user
        // print('User refreshed successfully: ${user!.displayName}');
      } catch (e) {
        print('Error refreshing user: $e');
      }
    } else {
      print('No user currently signed in.');
    }
  }



  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(BuildContext context) async {
    refreshUser();
    await _auth.signOut().whenComplete(() async {

      log("----emailController.text-----" +  emailController.text.trim());
      log("----passwordController.text-----" +  passwordController.text.trim());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim().toString(),
          password: passwordController.text);

      if (userCredential.user!.emailVerified) {
        // User is signed in and email is verified
        passwordController.clear();
        emailController.clear();
        await CommonMethod()
            .getXSnackBar("Success", 'Sign-in successfully', success)
            .whenComplete(() => Get.to(() => HomePage()));
      } else {
        // Email is not verified, handle accordingly
        await CommonMethod().getXSnackBar(
            "Error",
            'Email not verified. Check your inbox for the verification email.',
            red);
        print('');
      }
    } on FirebaseAuthException catch (e) {
      await CommonMethod()
          .getXSnackBar("Error", 'Failed to sign in: ${e.message}', red);
    }});
  }
  Future<User?> handleSignInGoogle() async {
    try {
      await googleSignIn
          .signOut(); // Sign out to allow multiple account selection
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled Google Sign-In
        await CommonMethod()
            .getXSnackBar("Info", 'Google Sign-In canceled by user', red);
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Successfully signed in with Google
        await CommonMethod()
            .getXSnackBar("Success", 'Signed in: ${user.displayName}', success)
            .whenComplete(() => Get.to(() => HomePage()));
      }

      return user;
    } catch (error) {
      // Handle specific error cases
      if (error is FirebaseAuthException) {
        await CommonMethod().getXSnackBar(
            "Error", 'Firebase Auth Error: ${error.message}', red);
      } else {
        // Handle other errors
        await CommonMethod()
            .getXSnackBar("Error", 'Error signing in with Google: $error', red);
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {

      await _auth.signOut().whenComplete(() {
        refreshUser().whenComplete(() =>
      Get.offAll(()=>LoginScreen()));
      });
    } catch (e) {
      CommonMethod().getXSnackBar("Error", 'Error signing out: $e', red);
    }
  }
  // Check if the user is currently signed in
  Future<bool> isUserSignedIn() async {
    return _auth.currentUser!=null;
  }

}
