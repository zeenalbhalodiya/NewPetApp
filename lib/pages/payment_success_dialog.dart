// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pet/pages/main_home_page.dart';
//
// class PaymentSuccessDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }
//
//   contentBox(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
//           margin: EdgeInsets.only(top: 45),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black,
//                 offset: Offset(0, 10),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                 "Payment Successful!",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 15),
//               Icon(
//                 Icons.done,
//                 color: Colors.green,
//                 size: 50,
//               ),
//               SizedBox(height: 22),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Get.offAll(()=>HomePage());
//                   },
//                   child: Text(
//                     "OK",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 0,
//           left: 20,
//           right: 20,
//           child: CircleAvatar(
//             backgroundColor: Colors.green,
//             radius: 45,
//             child: Icon(
//               Icons.check,
//               color: Colors.white,
//               size: 60,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// void showPaymentSuccessDialog(BuildContext context) {
//   showDialog(
//     // barrierDismissible: false,
//
//     context: context,
//     builder: (BuildContext context) {
//       return PaymentSuccessDialog();
//     },
//   );
// }
