import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/components/common_methos.dart';
import 'package:pet/pages/main_home_page.dart';
import 'dart:core';
import '../controller/data_controller.dart';
import '../controller/model/pet_model.dart';
import 'PaymentDetailsScreen.dart';
import 'package:intl/intl.dart';
class paymentScreen extends StatefulWidget {
  final PetModel pet;
  paymentScreen({required this.pet});
  @override
  _PaymentScreenState createState() => _PaymentScreenState(pet: pet);
}
class _PaymentScreenState extends State<paymentScreen> {
  final PetModel pet;
  _PaymentScreenState({required this.pet}) ;
  List<Map<String, dynamic>> paymentDetailsList = [];
  TextEditingController upiIdController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardholderNameController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String? selectedMonth;
  String? selectedYear;
  var controller = Get.put(DataController());
  User? user = FirebaseAuth.instance.currentUser;

  bool isVerifyButtonEnabled = false;
  // bool isLoading = false;

  CollectionReference payments =
  FirebaseFirestore.instance.collection('payments');
  CollectionReference upiDetails =
  FirebaseFirestore.instance.collection('upi_details');

  Future<void> fetchUPIDetails() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('upi_details').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Handle the fetched UPI ID data here
        // For example, update the UI or save to a list
      });
    } catch (error) {
      print("Failed to fetch UPI ID details: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch UPI ID details: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchPaymentDetails() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('payment').get();
      List<Map<String, dynamic>> tempList = [];
      // Process the fetched documents
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        tempList.add(data);
      });
      setState(() {
        paymentDetailsList = tempList;
      });
    } catch (error) {
      print("Failed to fetch payment details: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch payment details: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addPaymentDetails(PetModel petModel) async {
    try {
      var cardNumber = cardNumberController.text;
      var cardholderName = cardholderNameController.text;
      var cvv = cvvController.text;
      var expiryMonth = selectedMonth; // Assuming selectedMonth is String
      var expiryYear = selectedYear; // Assuming selectedYear is String

      // Add payment details to Firestore
      var docRef = await FirebaseFirestore.instance.collection('payments').add({
        'cardNumber': cardNumber,
        'cardholderName': cardholderName,
        'expiryDate': '$expiryMonth/$expiryYear',
        'cvv': cvv,
        'price': petModel.price,
        'imageLink': petModel.imageLink,
        'name': petModel.name,
        'petId': petModel.id,
        'timestamp': Timestamp.now(),
      });

      // Update the document with transactionId
      await FirebaseFirestore.instance.collection('payments').doc(docRef.id).update({
        'transactionId': docRef.id,
      });

      // Clear text fields
      cardNumberController.clear();
      cardholderNameController.clear();
      cvvController.clear();

      // Reset selected month and year
      selectedMonth = null;
      selectedYear = null;

      // Display success message
      CommonMethod().getXSnackBar("Success", "Payment Successfully done", success);

      // Navigate to HomePage
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

      // Open alert box
      openAlertBox();
    } catch (e) {
      // Handle errors here
      print('Error: $e');
      // Display error message
      CommonMethod().getXSnackBar("Error", "Failed to add payment details", red);
    }
  }



  Future<void> savePaymentDetails(
      String upiId,
      String cardNumber,
      String cardholderName,
      String expiryMonth,
      String expiryYear,
      String cvv,
      PetModel petModel,
      ) async {
    if (upiId.isEmpty) {
      _addPaymentDetails(petModel);

    } else {
      await FirebaseFirestore.instance.collection('upi_details').add({
        'upiId': upiId,
        'price': petModel.price,
        'imageLink': petModel.imageLink,
        'name': petModel.name,
        'petId': petModel.id,
        'timestamp': Timestamp.now(),
      }).then((DocumentReference docRef) {
        print("UPI ID added to Firestore with ID: ${docRef.id}");

        // Show success message
        upiIdController.clear();
        // CommonMethod().getXSnackBar("Success", "Payment Successfully done", success);
        // Get.off(()=>HomePage())!.then((value) => openAlertBox());


        // Display success message
        CommonMethod().getXSnackBar("Success", "Payment Successfully done", success);

        // Navigate to HomePage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

        // Open alert box
        openAlertBox();
      }).catchError((error) {
        // Handle errors here
        print("Error adding UPI ID: $error");
        CommonMethod().getXSnackBar("Error", "Failed to save UPI ID: $error", red);
      });
    }

    FirebaseFirestore.instance.collection('catadd').doc(petModel.id).update(
        {
          'isSold':true,
          "soldTime": DateTime.now(),
          "purchaseBy":user!.uid
        });
    controller.fetchPetDataFromFirestore();

  }


  openAlertBox() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "Payment Successful!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Done"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  void initState() {
    super.initState();
    upiIdController.addListener(updateVerifyButtonState);
  }

  void dispose() {
    upiIdController.removeListener(updateVerifyButtonState);
    super.dispose();
  }

  void updateVerifyButtonState() {
    setState(() {
      isVerifyButtonEnabled = upiIdController.text.isNotEmpty &&
          RegExp(r'^[a-zA-Z0-9@]+$').hasMatch(upiIdController.text);
    });
  }

  String getCurrentMonth() {
    DateTime now = DateTime.now();
    String formattedMonth = DateFormat('MMMM').format(now);
    return formattedMonth;
  }

  String getCurrentYear() {
    DateTime now = DateTime.now();
    String formatted = DateFormat('yyyy').format(now);
    return formatted;
  }
  void verifyUPIID() {
      String upiId = upiIdController.text;
      savePaymentDetails(
          upiId,
          cardNumberController.text,
          cardholderNameController.text,
          selectedMonth ?? getCurrentMonth(),
          selectedYear ?? getCurrentYear(),
          cvvController.text,pet);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: (){
            Get.to(()=>PaymentDetailsScreen());
          }, icon: Icon(Icons.history,color: primaryWhite,))],
          title: Text(
            'Payment Method',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Select Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text('Credit /Debit /ATM Card'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Credit Card Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20),
                                TextField(
                                  controller: cardNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Card Number',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CustomLengthLimitingTextInputFormatter(16),
                                    CustomCardNumberFormatter(),
                                  ],
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: cardholderNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Cardholder Name',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expiry Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ExpiryDateFormField(
                                        onChangedMonth: (month) {
                                          setState(() {
                                            selectedMonth = month;
                                          });
                                        },
                                        onChangedYear: (year) {
                                          setState(() {
                                            selectedYear = year;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: cvvController,
                                        decoration: InputDecoration(
                                          labelText: 'CVV',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(3)
                                        ],
                                        obscureText: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    String cardNumber =
                                    cardNumberController.text.trim();
                                    String cardholderName =
                                    cardholderNameController.text.trim();
                                    String expiryMonth = selectedMonth ?? '';
                                    String expiryYear = selectedYear ?? '';
                                    String cvv =
                                        cvvController.text.trim() ?? '';

                                    if (cardNumber.isEmpty ||
                                        cardholderName.isEmpty ||
                                        expiryMonth.isEmpty ||
                                        expiryYear.isEmpty ||
                                        cvv.isEmpty) {

                                      CommonMethod().getXSnackBar("Error", 'Please fill all the fields.', red);

                                      return;
                                    }

                                    savePaymentDetails(
                                      upiIdController.text,
                                      cardNumberController.text,
                                      cardholderNameController.text,
                                      selectedMonth!,
                                      selectedYear!,
                                      cvvController.text,
                                        pet
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Center(
                                      child: Text(
                                        'Pay Now',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text('UPI'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Enter UPI ID'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: upiIdController,
                                      decoration: InputDecoration(
                                        labelText: 'UPI ID',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 10.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    // if (isLoading)
                                    //   Center(
                                    //     child: CircularProgressIndicator(),
                                    //   ),
                                    ElevatedButton(
                                      onPressed: isVerifyButtonEnabled
                                          ? () {
                                          verifyUPIID();
                                          Navigator.pop(context);
                                        }
                                          : null,
                                      child: Text('Verify'),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return Colors.grey;
                                            }
                                            return Colors.lightBlue;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digits
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    var selectionIndex = newText.length;
    var formattedValue = '';
    for (var i = 0; i < newText.length; i += 4) {
      if (i > 0) {
        formattedValue += ' ';
        // If the selection index is after the inserted space, move it by 1
        if (selectionIndex > i) {
          selectionIndex++;
        }
      }
      formattedValue += newText.substring(i, i + 4);
    }
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class CustomLengthLimitingTextInputFormatter
    extends LengthLimitingTextInputFormatter {
  CustomLengthLimitingTextInputFormatter(int maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > maxLength!) {
      return oldValue;
    }
    return newValue;
  }
}

class ExpiryDateFormField extends StatefulWidget {
  final ValueChanged<String>? onChangedMonth;
  final ValueChanged<String>? onChangedYear;

  ExpiryDateFormField({this.onChangedMonth, this.onChangedYear});

  @override
  _ExpiryDateFormFieldState createState() => _ExpiryDateFormFieldState();
}

class _ExpiryDateFormFieldState extends State<ExpiryDateFormField> {
  String? selectedMonth;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedMonth,
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue;
                widget.onChangedMonth?.call(selectedMonth!);
              });
            },
            items: List.generate(12, (index) {
              return DropdownMenuItem<String>(
                value: (index + 1).toString().padLeft(2, '0'),
                child: Text((index + 1).toString().padLeft(2, '0')),
              );
            }),
            decoration: InputDecoration(
              labelText: 'MM',
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedYear,
            onChanged: (String? newValue) {
              setState(() {
                selectedYear = newValue;
                widget.onChangedYear?.call(selectedYear!);
              });
            },
            items: List.generate(10, (index) {
              return DropdownMenuItem<String>(
                value: (DateTime.now().year + index).toString().substring(2),
                child:
                Text((DateTime.now().year + index).toString().substring(2)),
              );
            }),
            decoration: InputDecoration(
              labelText: 'YY',
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            ),
          ),
        ),
      ],
    );
  }
}
