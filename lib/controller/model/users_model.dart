import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String email;
  final String? phone;
  final String password;
  final String confirmpassword;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmpassword,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      name: data['Name'],
      email: data['Email'],
      phone: data['Phone'],
      password: data['Password'],
      confirmpassword: data['Confirm Password'],
    );
  }

  toJson() {
    return {
      "Name": name,
      "Email": email,
      "Phone": phone,
      "Password": password,
      "Confirm Password": confirmpassword,
    };
  }
}
