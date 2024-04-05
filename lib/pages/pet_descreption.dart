import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/configuration/configuration.dart';
import 'package:pet/controller/data_controller.dart';
import 'package:pet/pages/paymentScreen.dart';
import '../controller/model/pet_model.dart';

class DescriptionScreen extends StatefulWidget {
  final PetModel pet;
  DescriptionScreen({required this.pet});
  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool isFavorite = false;
  var controller = Get.put(DataController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blueGrey[300],
                    child: Image.network(
                      widget.pet.imageLink.toString(),
                      height: 300,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                widget.pet.description.toString(),
                                style: AppTextStyle.normalRegular16
                                    .copyWith(color: primaryColor),
                              ),
                            ),
                          ),
                        ])
                      ]),
                    ),],
            )),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(icon: Icon(Icons.share), onPressed: () {})
                  ],
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 40),
            //   child: Align(
            //     alignment: Alignment.topCenter,
            //     child: Hero(
            //         tag: 1,
            //         child: Image.network(widget.pet.imageLink.toString(),height: 300,width: Get.width,fit: BoxFit.cover,)),
            //   ),),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 150,
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(20)),

                //database
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 65,
                        ),
                        Text(
                          widget.pet.name.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.female_rounded,
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.pet.weight.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.pet.age + ' Year old',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.pet.breed.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.pet.priceText.toString() + ' Rs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.pet.lifespan.toString() + ' Lifespan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 100,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.updatePetDataInFirestore(
                            widget.pet.id.toString(), widget.pet, user!.uid);
                        setState(() {});
                      },
                      child: FutureBuilder<bool>(
                        future: controller.isUserIdInFavorite(
                            widget.pet.id.toString(), user!.uid.toString()),
                        builder: (context, snapshot) {
                          return Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                snapshot.data != null && snapshot.data!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to PaymentScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => paymentScreen(pet: widget.pet,),
                            ),
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text('Adoption',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
