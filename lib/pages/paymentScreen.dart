import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pet/app.dart';
import 'package:pet/components/colors.dart';
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
  bool isLoading = false;

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
    await FirebaseFirestore.instance.collection('payments').add({
        'cardNumber': cardNumber,
        'cardholderName': cardholderName,
        'expiryDate': '$expiryMonth/$expiryYear',
        'cvv': cvv,
        'price': petModel.price,
        'imageLink': petModel.imageLink,
        'name': petModel.name,
        'petId': petModel.id,
        'timestamp': Timestamp.now(),
      }).then((DocumentReference docRef) {
        print("Payment details added to Firestore with ID: ${docRef.id}");
         FirebaseFirestore.instance.collection('payments').doc(docRef.id).update(
            {
              'transactionId':docRef.id
            });
        cardNumberController.clear();
        cardholderNameController.clear();
        cvvController.clear();
        setState(() {
          selectedMonth = null;
          selectedYear = null;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentDetailsScreen()),
        );
      }).catchError((error) {
        print("Failed to save payment details: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save payment details: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });

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

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentDetailsScreen(),
        ));
      }).catchError((error) {
        print("Failed to save UPI ID: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save UPI ID: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    FirebaseFirestore.instance.collection('catadd').doc(petModel.id).update(
        {
          'isSold':true,
          "purchaseBy":user!.uid
        });
    controller.fetchPetDataFromFirestore();

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
    setState(() {
      isLoading = true;
    });



    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

      String upiId = upiIdController.text;

      savePaymentDetails(
          upiId,
          cardNumberController.text,
          cardholderNameController.text,
          selectedMonth ?? getCurrentMonth(),
          selectedYear ?? getCurrentYear(),
          cvvController.text,pet)
          .then((_) {
        print("Payment details saved");
      }).catchError((error) => print("Failed to save payment details: $error"));
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentDetailsScreen()),
        ).then((value) {});
      });
    });
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please fill all the fields.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });
                                    savePaymentDetails(
                                      upiIdController.text,
                                      cardNumberController.text,
                                      cardholderNameController.text,
                                      selectedMonth!,
                                      selectedYear!,
                                      cvvController.text,
                                        pet
                                    ).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Payment details saved successfully'),
                                        ),
                                      );
                                    }).catchError((error) {
                                      print(
                                          "Failed to save payment details: $error");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to save payment details: $error'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }).whenComplete(() {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Center(
                                      child: isLoading
                                          ? CircularProgressIndicator()
                                          : Text(
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
                                    if (isLoading)
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ),
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