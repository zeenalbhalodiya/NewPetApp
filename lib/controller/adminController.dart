import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pet/controller/model/pet_model.dart';
import 'model/users_model.dart';

class AdminController extends GetxController{
RxList<UserModel> allUserList = <UserModel>[].obs;
RxList<PetModel> allPetList = <PetModel>[].obs;
RxList<PetModel> allCatSoldList = <PetModel>[].obs;
RxList<PetModel> allDogSoldList = <PetModel>[].obs;
RxList<PetModel> allCatList = <PetModel>[].obs;
RxList<PetModel> allDogList = <PetModel>[].obs;

Future getPetList() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('catadd').get();
  List<PetModel> petList = querySnapshot.docs.map((doc) {
    return PetModel.fromJson({
      ...doc.data() as Map<String, dynamic>,
      'id': doc.id,
    });
  }).toList();
  allPetList.value = petList;
  allCatList.value = petList.where((pet) => pet.category == "Cat").toList();
  allDogList.value = petList.where((pet) => pet.category == "Dog").toList();

  allCatList.refresh();
  allDogList.refresh();

  allCatSoldList.value = allCatList.where((pet) => pet.isSold == true).toList();
  allDogSoldList.value = allCatList.where((pet) => pet.isSold == true).toList();

  allCatSoldList.refresh();
  allDogSoldList.refresh();
  allPetList.refresh();
}

Future getUserList() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  List<UserModel> userList = querySnapshot.docs.map((doc) {
    return UserModel.fromJson({
      ...doc.data() as Map<String, dynamic>,
      'id': doc.id,
    });
  }).toList();

  allUserList.value = userList;
  allDogSoldList.refresh();
}



}