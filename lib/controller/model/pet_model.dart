import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  String? id;
  String? userId;
  String? name;
  String? price;
  dynamic age;
  String? imageLink;
  String? category;
  String? description;
  List<String> favorite;
  String? breed;
  String? lifespan;
  String? weight;
  String? tax;
  String? priceText;
  bool? isSold;
  // String? soldTime;
  String? purchaseBy;

  PetModel({
    this.id,
    this.userId,
    this.name,
    this.price,
    this.age,
    this.imageLink,
    this.category,
    this.description,
    this.favorite = const [],
    this.breed,
    this.lifespan,
    this.weight,
    this.tax,
    this.priceText,
    this.isSold,
    // this.soldTime,
    this.purchaseBy,
  });

  // factory PetModel.fromJson(Map<String, dynamic> json) {
  //   List<String>? favorites = List<String>.from(json['favorite'] ?? []);
  //   return PetModel(
  //     id: json['id'],
  //     userId: json['userId'],
  //     name: json['name'],
  //     price: json['price'],
  //     age: json['age'],
  //     imageLink: json['imageLink'],
  //     category: json['category'],
  //     description: json['description'],
  //     favorite: favorites,
  //     breed: json['breed'],
  //     lifespan: json['lifespan'],
  //     weight: json['weight'],
  //     tax: json['tax'],
  //     priceText: json['priceText'],
  //     isSold: json['isSold'],
  //     soldTime: json['soldTime'] != null ? (json['soldTime'] as Timestamp).toDate() : null,
  //     // soldTime: json['soldTime'] != null ? DateTime.parse(json['soldTime']) : null,
  //     purchaseBy: json['purchaseBy'],
  //   );
  // }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    List<String>? favorites = List<String>.from(json['favorite'] ?? []);
    return PetModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      price: json['price'],
      age: json['age'],
      imageLink: json['imageLink'],
      category: json['category'],
      description: json['description'],
      favorite: favorites,
      breed: json['breed'],
      lifespan: json['lifespan'],
      weight: json['weight'],
      tax: json['tax'],
      priceText: json['priceText'],
      isSold: json['isSold'],
      // soldTime: json['soldTime'] != null ? DateTime.parse(json['soldTime']) : null,
      // soldTime: json['soldTime'],

      purchaseBy: json['purchaseBy'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'price': price,
      'age': age,
      'imageLink': imageLink,
      'category': category,
      'description': description,
      'favorite': favorite,
      'breed': breed,
      'lifespan': lifespan,
      'weight': weight,
      'tax': tax,
      'priceText': priceText,
      'isSold': isSold,
      // 'soldTime': soldTime ,
      'purchaseBy': purchaseBy,
    };
  }
}
