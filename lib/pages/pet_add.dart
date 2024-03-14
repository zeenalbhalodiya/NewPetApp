import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/components/common_methos.dart';
import 'package:pet/pages/utils.dart';
import '../configuration/configuration.dart';
import '../controller/data_controller.dart';
import '../controller/model/pet_model.dart';
import '../utils/process_indicator.dart';
import 'contactus.dart';
import 'home_screen.dart';
import 'main_home_page.dart';

class PetAdd extends StatefulWidget {
  const PetAdd({Key? key});

  @override
  State<PetAdd> createState() => _PetAddState();
}

class _PetAddState extends State<PetAdd> {
  Uint8List? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  String? selectedAge;
  String? selectedCategory;
  String? selectedBreed;
  String? selectedLifespan;
  String? selectedWeight;
  String? description;
  double? tax;
  static Circle processIndicator = Circle();

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
  Future<String> uploadPetImage(Uint8List image) async {
    throw UnimplementedError('uploadPetImage method is not implemented');
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }

  void initState() {
    super.initState();
    priceController.addListener(_updateTax);
    _updateTax();
  }

  void _updateTax() {
    double price = double.tryParse(priceController.text) ?? 0;
    double tax = price * 0.02;
    taxController.text = tax.toStringAsFixed(2);
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    double price = double.tryParse(priceController.text) ?? 0;
    double tax = double.tryParse(taxController.text) ?? 0;
    double totalPrice = price + tax;
    totalPriceController.text = totalPrice.toStringAsFixed(2);
  }

  void dispose() {
    priceController.removeListener(_updateTax);
    super.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future _handleAddButton(BuildContext context) async {
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

      CommonMethod().getXSnackBar("Error", "All fields are required.", Colors.red);
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('All fields are required.'),
      //   ),
      // );
      return;
    }else{
      try {
        await saveData(petModel: PetModel(
            name: nameController.text?? '',
            price: double.parse(priceController.text).toString(),
            age: selectedAge ?? '',
            category: selectedCategory ?? '',
            description: description ?? '',
            favorite: [],
isSold: false,
            breed: selectedBreed ?? '',
            lifespan: selectedLifespan ?? '',
            weight: selectedWeight ?? '',
            tax: taxController.text,
            priceText: totalPriceController.text, imageLink: '', purchaseBy: ''
        ), file: _image!,context: context);

      }catch (error) {
        // Show error message if saving data fails

        CommonMethod().getXSnackBar("Error", "Failed to add: $error", Colors.red);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to add: $error'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      }
    }
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );

    // await Future.delayed(Duration(seconds: 2));
    // Get.back();
    // setState(() {
    //   isLoading = true;
    // });

    // Future.delayed(Duration(seconds: 1), () {
    //   // Navigator.of(context).pop();
    //   Get.back();
    // });

    // Delay the navigation to give time for the user to see the success message
    // Future.delayed(Duration(seconds: 2), () {
    //   // Navigate to the home page
    //   Navigator.of(context).pop(); // Close the current screen
    // });
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async{
    Reference ref = _storage.ref().child(childName).child(file.length.toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveData({
    required PetModel petModel,
    required Uint8List file,
    required BuildContext context,
  }) async {
    try {
      // String imageUrl = (await uploadPetImage) as String;
      processIndicator.show(context);
      String imageUrl = await uploadImageToStorage('catadd', file).whenComplete(() {
        processIndicator.hide(context);
      });
      petModel.imageLink = imageUrl;
      // await FirebaseFirestore.instance.collection('catadd').add({
      //   'name': petModel.name,
      //   'price': petModel.price,
      //   'age': petModel.age,
      //   'image_Link': petModel.imageLink,
      //   'category': petModel.category,
      //   'description': petModel.description,
      //   'favorite': petModel.favorite,
      //   'breed': petModel.breed,
      //   'lifespan': petModel.lifespan,
      //   'weight': petModel.weight,
      //   'tax': petModel.tax,
      //   'priceText': petModel.priceText
      // });

      await FirebaseFirestore.instance.collection('catadd').add(petModel.toJson());

      log("-----petModel------${petModel.toJson()}");
      // Get.back();
      // Get.back();
      Get.to(()=>HomePage());

      CommonMethod().getXSnackBar("Success", 'Successfully added!', success);

    } catch (error) {
      processIndicator.hide(context);
      CommonMethod().getXSnackBar("Success", 'Failed to add pet: $error', red);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Add", style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor,
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
                    backgroundImage: AssetImage('assets/images/png/avatar-pet.png'),),
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                    decoration: InputDecoration(
                      labelText: 'Type of Breed',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                    decoration: InputDecoration(
                      labelText: 'Lifespan',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: taxController,
                    decoration: InputDecoration(
                      labelText: 'Tax (2%)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    onTap: () {
                      double price =
                          double.tryParse(priceController.text) ?? 0;
                      double tax = price * 0.02;
                      taxController.text = tax.toStringAsFixed(2);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: totalPriceController,
                    decoration: InputDecoration(
                      labelText: 'Total Price',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    onChanged: (value) {
                      double price =
                          double.tryParse(priceController.text) ?? 0;
                      tax = double.tryParse(taxController.text) ?? 0;
                      double totalPrice = price + tax!;
                      totalPriceController.text =
                          totalPrice.toStringAsFixed(2);
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await _handleAddButton(context);

                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(150, 50),
                ),
                child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}