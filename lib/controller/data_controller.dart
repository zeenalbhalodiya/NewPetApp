import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet/controller/model/users_model.dart';
import 'model/pet_model.dart';

class DataController extends  GetxController {
  RxString selectedCategoryName = 'All'.obs;
  RxList<PetModel> petDataList = <PetModel>[].obs;
  RxList<PetModel> favoritePetDataList = <PetModel>[].obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
RxList paymentTransferList = [].obs;
RxList upiTransferList = [].obs;
RxList soldIdList = [].obs;
  String adminEmail = "petapplication2@gmail.com";

TextEditingController searchTextController = TextEditingController();

  Future getTransferHistory() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('payments').get();
    List<Map<String, dynamic>> pTransferList = [];
    querySnapshot.docs.forEach((doc) {
      pTransferList.add(doc.data() as Map<String, dynamic>);
    });
    paymentTransferList.value = pTransferList;
    update();

    QuerySnapshot query =
    await FirebaseFirestore.instance.collection('upi_details').get();
    List<Map<String, dynamic>> uTransferList = [];
    query.docs.forEach((doc) {
      uTransferList.add(doc.data() as Map<String, dynamic>);
    });
    upiTransferList.value = uTransferList;
    update();

    log("-----paymentTransferList-----${paymentTransferList.value.length}");
    log("-----upiTransferList-----${upiTransferList.value.length}");
  }

  Future<UserModel> getUserModel(String userId) async {
    UserModel userModel = UserModel(
      name: '',
      email: '',
      phone: '',
      password: '',
      confirmpassword: '', id: '',
    );

    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (snapshot.exists) {
        userModel = UserModel.fromDocumentSnapshot(snapshot);
        print(userModel.name); // Accessing user's name
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error accordingly
    }
log('--------userModel------${userModel.toJson()}');
log('--------userId------${userId}');
log('--------user------${user.toString()}');
    return userModel;
  }


  Future<String> getTransactionId(String? petId) async {
    if (petId != null) {
      var documentSnapshot = await FirebaseFirestore.instance.collection(
          'payments').doc(petId).get();
      var transactionId = documentSnapshot['transactionId'];
      return transactionId.toString();
    } else {
      throw Exception('Pet ID is null');
    }
  }
  @override
  void onInit() {
    super.onInit();
    // Fetch pet data when the controller is initialized
    fetchPetDataFromFirestore();
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async{
    Reference ref = _storage.ref().child(childName).child(file.length.toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveData({required PetModel petModel,required Uint8List file}) async {
    try {
      // Convert PetModel object to a Map
      String imageUrl = await uploadImageToStorage('catadd', file);
      petModel.imageLink = imageUrl;
      Map<String, dynamic> petData = petModel.toJson();
      // Add the pet data to Firestore
      await FirebaseFirestore.instance.collection('catadd').add(petData);
      Get.back();
      Get.back();
      print('Pet added to Firestore successfully');
    } catch (error) {
      print('Error adding pet to Firestore: $error');
    }
  }

  Future searchPets(String query) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('catadd').get();
    List<PetModel> petList = querySnapshot.docs.map((doc) {
      return PetModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    }).toList();

    if (query.isEmpty) {
      // Show all pets when the search bar is empty
      petDataList.value = petList;
    } else {
      // Filter pets based on the entered text
      List<PetModel> filteredPets = petList.where((pet) {
        final searchText = searchTextController.text.toLowerCase().trim();
        if (searchText.isEmpty) {
          return true; // Show all pets if search text is empty
        } else {
          return pet.breed?.toLowerCase().contains(searchText) ?? false;
        }
      }).toList();
      petDataList.value = filteredPets;
    }
    petDataList.refresh();

  }

  Future<List<PetModel>> fetchPetDataFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('catadd').get();
    List<PetModel> petList = querySnapshot.docs.map((doc) {
      return PetModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    }).toList();

    if(selectedCategoryName.value == "All"){
      petDataList.value = petList;
    }else{
      petDataList.value = petList.where((pet) => pet.category == selectedCategoryName.value).toList();
    }
    // favoritePetDataList.value = petList.where((pet) => pet.favorite == selectedCategoryName.value).toList();
    favoritePetDataList.value = petList.where((pet) => pet.favorite!.contains(user!.uid)).toList();
    petDataList.refresh();

    if(user!.email == adminEmail){
      petDataList.value = petDataList.value.where((pet) => pet.isSold == true).toList();

    }
    favoritePetDataList.refresh();
    petDataList.refresh();
    update();
    return petList;
  }

  Future<void> updatePetDataInFirestore(String petId, PetModel updatedData, String userId) async {
    print("-----updatePetDataInFirestore------");

    try {
      updatedData.favorite ??= [];

      DocumentReference petRef = FirebaseFirestore.instance.collection('catadd').doc(petId);

      if (updatedData.favorite!.contains(userId)) {
        print("-----updatePetDataInFirestore------if");
        updatedData.favorite!.remove(userId);
      } else {
        print("-----updatePetDataInFirestore------else");
        updatedData.favorite!.add(userId);
      }
      // Convert PetModel object to map
      Map<String, dynamic> dataToUpdate = updatedData.toJson();

      // Update the document with the new data
      await petRef.update(dataToUpdate);
      print('Document with ID $petId successfully updated.');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<bool> isUserIdInFavorite(String petId, String userId) async {
    try {
      // Get the reference to the document in Firestore
      DocumentSnapshot petSnapshot = await FirebaseFirestore.instance.collection('catadd').doc(petId).get();
      // Check if the document exists
      if (petSnapshot.exists) {
        // Get the data from the document
        Map<String, dynamic>? petData = petSnapshot.data() as Map<String, dynamic>?;
        // Check if the 'favorite' field exists and if it contains the userId
        if (petData != null && petData['favorite'] is List<dynamic>) {
          return (petData['favorite'] as List<dynamic>).contains(userId);
        }
      }
      // Return false if the document doesn't exist or 'favorite' field is not found
      return false;
    } catch (error) {
      print('Error checking if userId is in favorite: $error');
      return false;
    }
  }
// Future<void> updatePetDataInFirestore(String petId, PetModel updatedData, String userId) async {
//   log("-----updatePetDataInFirestore----");
//   try {
//     // Get the reference to the document in Firestore
//     DocumentReference petRef = Firebaseirestore.instance.collection('catadd').doc(petId);
//
//     // Convert PetModel object to map
//     Map<String, dynamic> dataToUpdate = updatedData.toJson();
//
//     // If userId exists in the favorite array, remove it; otherwise, add it
//     if (updatedData.favorite!.contains(userId)) {
//       dataToUpdate['favorite'] = FieldValue.arrayRemove([userId]);
//     } else {
//       dataToUpdate['favorite'] = FieldValue.arrayUnion([userId]);
//     }
//
//     // Update the document with the new data
//     await petRef.update(dataToUpdate);
//     print('Document with ID $petId successfully updated.');
//   } catch (error) {
//     print('Error updating document: $error');
//   }
// }

// Future<void> updatePetDataInFirestore(String petId, PetModel updatedData) async {
//   try {
//     // Get the reference to the document in Firestore
//     DocumentReference petRef = FirebaseFirestore.instance.collection('catadd').doc(petId);
//
//     // Convert PetModel object to map
//     Map<String, dynamic> dataToUpdate = updatedData.toJson();
//
//     // Update the document with the new data
//     await petRef.update(dataToUpdate);
//     print('Document with ID $petId successfully updated.');
//   } catch (error) {
//     print('Error updating document: $error');
//   }
// }

// bool isPetFavorite(String petId) {
//   return petFavoriteIds.contains(petId);
// }
// void toggleFavoriteStatus(String petId) {
//   if (isPetFavorite(petId)) {
//     petFavoriteIds.remove(petId);
//   } else {
//     petFavoriteIds.add(petId);
//   }
//   update();
// }
}
