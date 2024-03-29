import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/controller/model/users_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // createUser(UserModel user) async {
  //   await _db.collection("users").add(user.toJson()).whenComplete(() =>
  //       Get.snackbar("success", "you account has been created",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green.withOpacity(0.1),
  //           colorText: Colors.green),
  //   )
  //       .catchError((error, stackTrace) {
  //     Get.snackbar("error", "something went wrong.try again",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent.withOpacity(0.1),
  //         colorText: Colors.redAccent);
  //     print(error.toString());
  //   });
  // }

  createUser(String userId, UserModel user) async {
    try {
      await _db.collection("users").doc(userId).set(user.toJson());
      Get.snackbar("Success", "Your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    } catch (error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Please try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.redAccent);
      print(error.toString());
    }
  }

}
