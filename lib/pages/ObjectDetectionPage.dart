// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// Future<void> detectCatImage(String imageUrl) async {
//   String apiKey = 'YOUR_API_KEY';
//   String apiUrl = 'API_ENDPOINT';
//
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'imageUrl': imageUrl,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Parse response JSON
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       bool isCatDetected = responseData['isCatDetected'];
//
//       if (isCatDetected) {
//         // Cat is detected, handle accordingly
//         print('Cat detected in the image!');
//       } else {
//         // No cat detected
//         print('No cat detected in the image.');
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
