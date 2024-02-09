
class PetModel {
   String? id;
   String? name;
   String? price;
   dynamic age;
   String? imageLink;
   String? category;
   String? description;
   List<String> favorite;

  PetModel({
     this.id,
    required this.name,
    required this.price,
    required this.age,
    required this.imageLink,
    required this.category,
    required this.description,
    required this.favorite,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    List<String>? favorites = (json['favorite'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    return PetModel(
      id: json['id'] ,
      name: json['name'],
      price: json['price'],
      age: json['age'],
      imageLink: json['imageLink'],
      category: json['category'],
      description: json['description'],
      favorite: favorites ?? [],    );
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
    };

    // Remove key-value pairs with null or empty string values
    json.removeWhere((key, value) => value == null || value == '');

    return json;
}
}
