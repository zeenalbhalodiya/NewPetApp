// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pet/pages/utils.dart';
// import 'package:tflite/tflite.dart';
//
// class ObjectDetectionPage extends StatefulWidget {
//   @override
//   _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
// }
//
// class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
//   Uint8List? _image;
//   String? detectedObject;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }
//
//   Future<void> loadModel() async {
//     String? res = await Tflite.loadModel(
//       model: 'assets/model.tflite',
//       labels: 'assets/labels.txt',
//     );
//     print(res);
//   }
//
//   Future<void> detectObjects(Uint8List image) async {
//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = tempDir.path;
//     late File tempFile = File('$tempPath/image.jpg');
//     await tempFile.writeAsBytes(image);
//
//     try {
//       List? recognitions = await Tflite.detectObjectOnImage(
//         path: tempFile.path,
//         model: 'YOLO',
//         imageMean: 0.0,
//         imageStd: 255.0,
//         threshold: 0.3,
//         numResultsPerClass: 1,
//       );
//
//       recognitions?.forEach((element) {
//         if (element['detectedClass'] == 'cat' ||
//             element['detectedClass'] == 'dog') {
//           setState(() {
//             detectedObject = element['detectedClass'];
//           });
//         }
//       });
//     } catch (e) {
//       print('Error detecting objects: $e');
//     }
//   }
//
//   void selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     await detectObjects(img);
//     setState(() {
//       _image = img;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Object Detection'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_image != null) ...[
//               Image.memory(
//                 _image!,
//                 width: 300,
//                 height: 300,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 detectedObject ?? 'No cat or dog detected',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ],
//             ElevatedButton(
//               onPressed: selectImage,
//               child: Text('Select Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class BackendBloc extends Cubit<String> {
//   BackendBloc() : super('');
//
//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse('http://localhost:5000/api/data'));
//     if (response.statusCode == 200) {
//       emit(response.body);
//     } else {
//       emit('Failed to fetch data');
//     }
//   }
// }
