import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? password;
  final String? confirmpassword;

  const UserModel({
    required this.id,
    required this.imageUrl,
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
      imageUrl: data['imageUrl'],
      email: data['Email'],
      phone: data['Phone'],
      password: data['Password'],
      confirmpassword: data['Confirm Password'],
    );
  }

  toJson() {
    Map<String, dynamic> json = {
      "id": id,
      "Name": name,
      "Email": email,
      "imageUrl": imageUrl,
      "Password": password,
      "Phone": phone,
      "Password": password,
      "Confirm Password": confirmpassword,
    };

    // Add phone only if it's not null
    if (phone != null) {
      json["Phone"] = phone;
    }

    // Filter out null values
    json.removeWhere((key, value) => value == null);

    return json;
  }

}
