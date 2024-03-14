import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/components/static_decoration.dart';
import 'package:pet/controller/data_controller.dart';
import 'package:pet/controller/model/pet_model.dart';
import 'package:pet/widget/shadow_container_widget.dart';
import '../configuration/configuration.dart';

class PaymentDetailsScreen extends StatefulWidget {

  PaymentDetailsScreen();

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  var controller = Get.put(DataController());
  @override
  void initState() {
    controller.getTransferHistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: Text('Payment Details', style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
      ),
      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: Text("Card Transaction",style: AppTextStyle.normalBold18),
          ),
          Obx(() =>
          Column(children: controller.paymentTransferList.value.map((e) => animalWidget(false,e)).toList(),)),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text("UPI Transaction",style: AppTextStyle.normalBold18,),
          ),

          Obx(() => Column(children: controller.upiTransferList.value.map((e) => animalWidget(true,e)).toList(),)),


        ],
      ),
    );
  }

  Widget animalWidget(bool isUpi,var data){
    return

    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShadowContainerWidget(widget: Row(children: [
        if(data['imageLink'] != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            data['imageLink'].toString(),
            // height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(isUpi? "UPI ID :":'Transaction ID :',style: AppTextStyle.normalRegular14.copyWith(color: grey),
          ),
            Text(isUpi? "${data['upiId']}": '${data['transactionId']}',style: AppTextStyle.normalRegular14.copyWith(color: appColor),
            ),
height05,
            Text("Name :",style: AppTextStyle.normalRegular14.copyWith(color: grey),
            ),
            Text('${data['name']}',style: AppTextStyle.normalRegular14.copyWith(color: appColor),
            ),
        ],)
      ],)),
    );





      AnimatedContainer(
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: shadowList,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      data['imageLink'].toString(),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 40, bottom: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: shadowList,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'].toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                           isUpi? "UPI ID: ${data['upiId']}":   'Transaction ID: ${data['transactionId']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Price: ${data['price']} Rs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
