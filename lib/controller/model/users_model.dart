import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? password;
  // final String? confirmPassword;

  const UserModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    // required this.confirmPassword,
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
      // confirmPassword: data['Confirm Password'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['Name'],
      imageUrl: json['imageUrl'],
      email: json['Email'],
      phone: json['Phone'],
      password: json['Password'],
      // confirmPassword: json['Confirm Password'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "id": id,
      "Name": name,
      "Email": email,
      "imageUrl": imageUrl,
      "Password": password,
      "Phone": phone,
      // "Confirm Password": confirmPassword,
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
