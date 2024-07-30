// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// Future<void> detectDogOrCat(String imagePath) async {
//   // Replace with your Petfinder API key
//   const String apiKey = 'YOUR_PETFINDER_API_KEY';
//   const String apiUrl = 'https://api.petfinder.com/v2/animals';
//
//   // Read image file as bytes
//   final imageBytes = await File(imagePath).readAsBytes();
//
//   try {
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Authorization': 'Bearer $apiKey',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // Parse response JSON
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       List<dynamic> animals = responseData['animals'];
//
//       // Check if there are any cats or dogs in the response
//       bool isDogOrCat = animals.any((animal) => animal['type'] == 'Cat' || animal['type'] == 'Dog');
//
//       if (isDogOrCat) {
//         // Cat or dog is detected, you can proceed with further actions
//         print('Cat or dog detected in the image!');
//       } else {
//         // No cat or dog detected, display error message
//         print('Only cat and dog images are allowed!');
//       }
//     } else {
//       // Handle error response
//       print('Error: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Handle exceptions
//     print('Exception: $e');
//   }
// }
