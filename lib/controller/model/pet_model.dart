import 'dart:typed_data';

class PetModel {
  String? id;
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
  String? purchaseBy;


  PetModel({
    this.id,
    required this.name,
    required this.price,
    required this.age,
    required this.imageLink,
    required this.category,
    required this.description,
    required this.favorite,
    required this.breed,
    required this.lifespan,
    required this.weight,
    required this.tax,
    required this.priceText,
    required this.isSold,
    required this.purchaseBy,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    List<String>? favorites = (json['favorite'] as List<dynamic>?)?.map((e) =>
        e.toString()).toList();
    return PetModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      age: json['age'],
      imageLink: json['imageLink'],
      category: json['category'],
      description: json['description'],
      favorite: favorites ?? [],
      breed: json['breed'],
      lifespan: json['lifespan'],
      weight: json['weight'],
      tax: json['tax'],
      priceText: json['priceText'],
      isSold: json['isSold'],
      purchaseBy: json['purchaseBy'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
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
      'isSold': isSold,
      'priceText': priceText,
      'purchaseBy': purchaseBy,
    };

    // Remove key-value pairs with null or empty string values
    json.removeWhere((key, value) => value == null || value == '');
    return json;
  }
}