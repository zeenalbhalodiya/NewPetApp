import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/pages/utils.dart';
import '../configuration/configuration.dart';
import '../controller/data_controller.dart';
import '../controller/model/pet_model.dart';

class PetAdd extends StatefulWidget {
  const PetAdd({Key? key});

  @override
  State<PetAdd> createState() => _PetAddState();
}

class _PetAddState extends State<PetAdd> {
  Uint8List? _image;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedAge;
  String? selectedCategory;
  String? selectedBreed;
  String? selectedLifespan;
  String? selectedWeight;
  String? description;

  var controller = Get.put(DataController());
  List<String> ageList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    'more'
  ];

  List<String> breedList = [
    'Bombay Cat',
    'Himalayan Cat',
    'Siamese Cat',
    'Rusty-Spotted Cat',
    'Ragdoll Cat',
    'Birman Cat',
    'Abyssinian Cat',
    'Oriental Shorthair Cat',
    'Tonkinese Cat',
    'Persian Cat',
    'Maine Coon Cat',
    'The American Bobtail Cat',
    'Bengal Cat',
    'Sphynx Cat',
    'Turkish Van Cat',
    'Spotted Cat or Indian Billi',
    'Exotic Cat',
    'Leopard Cat',
    'British Shorthair Cat',
    'Russian Blue Cat',
    'Scottish Fold Cat',
    'American Shorthair Cat',
    'Turkish Angora Cat',
    'German shepherd Dog',
    'Great Dane Dog',
    'Beagles',
    'Golden Retriever Dog',
    'Pug Dog',
    'Pomeranian Dog',
    'Shih Tzu Dog',
    'Siberian Husky Dog',
    'Indies Dog',
    'Labrador Dog',
    'Cocker Spaniel Dog',
    'Rottweiler Dog',
    'Boxer Dog',
    'Dachshund Dog',
    'Doberman Dog',
    'Indian Pariah Dog',
    'Bulldog',
    'Saint Bernard Dog',
    'Pitt Bull Dog',
    'Border Collie Dog',
    'Chihuahua Dog',
    'Rhodesian Ridgeback Dog'
  ];

  List<String> lifespan = [
    '1 Year',
    '2 Year',
    '3 Year',
    '4 Year',
    '5 Year',
    '6 Year',
    '7 Year',
    '8 Year',
    '9 Year',
    '10 Year',
    '11 Year',
    '12 Year',
    '13 Year',
    '14 Year',
    '15 Year',
    '16 Year',
    '17 Year',
    '18 Year',
    '19 Year',
    '20 Year'
  ];

  List<String> weight = [
    '1 Kg',
    '2 Kg',
    '3 Kg',
    '4 Kg',
    '5 Kg',
    '6 Kg',
    '7 Kg',
    '8 Kg',
    '9 Kg',
    '10 Kg',
    '11 Kg',
    '12 Kg',
    '13 Kg',
    '14 Kg',
    '15 Kg',
    '16 Kg',
    '17 Kg',
    '18 Kg',
    '19 Kg',
    '20 Kg'
  ];

  bool isLoading = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future _handleAddButton() async {
    if (description!.split(' ').length < 20|| description!.split(' ').length > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Description must contain 20 to 60 words.'),
        ),
      );
      return;
    }
    if (_image == null ||
        nameController.text.isEmpty ||
        selectedAge == null ||
        selectedCategory == null ||
        description == null ||
        description!.isEmpty ||
        priceController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required.'),
        ),
      );
      return;
    }
    BuildContext scaffoldContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    String name = nameController.text;
    String age = selectedAge ?? '';
    String price = priceController.text;

    await controller.saveData(petModel:PetModel(
      name: name,
      price: price,
      age: age,
      imageLink: '',
      category: selectedCategory ?? '',
      description: description ?? '',
      favorite: [],
      breed: selectedBreed,
      lifespan: selectedLifespan,
      weight: selectedWeight,
    ),
      file: _image!,
    );
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(scaffoldContext).showSnackBar( // Use stored context
      SnackBar(
        content: Text('Successfully added!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Delay the navigation to give time for the user to see the success message
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the home page
      Navigator.of(scaffoldContext).pop(); // Close the current screen
    });

    // setState(() {
    //   isLoading = false;
    // });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Successfully added!'),
    //     duration: Duration(seconds: 2),
    //   ),
    // );

    // Delay the navigation to give time for the user to see the success message
    // Future.delayed(Duration(seconds: 2), () {
    //   // Navigate to the home page
    //   Navigator.of(context).pop(); // Close the current screen
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Add"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'Z:\Intern-PetApp-main\assets\images\png\avatar-pet.png'),                      ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedAge,
                  onChanged: (String? value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                  items: ageList
                      .map((age) => DropdownMenuItem<String>(
                    value: age,
                    child: Text(age),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Age'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                    value: category['name'],
                    child: Text(category['name']),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedBreed,
                  onChanged: (String? value) {
                    setState(() {
                      selectedBreed = value;
                    });
                  },
                  items: breedList
                      .map((breed) => DropdownMenuItem<String>(
                    value: breed,
                    child: Text(breed),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Type of Breed'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedLifespan,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLifespan = value;
                    });
                  },
                  items: lifespan
                      .map((lifespan) => DropdownMenuItem<String>(
                    value: lifespan,
                    child: Text(lifespan),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Lifespan'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedWeight,
                  onChanged: (String? value) {
                    setState(() {
                      selectedWeight = value;
                    });
                  },
                  items: weight
                      .map((weight) => DropdownMenuItem<String>(
                    value: weight,
                    child: Text(weight),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Weight'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleAddButton,
                child: Text('Add'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
