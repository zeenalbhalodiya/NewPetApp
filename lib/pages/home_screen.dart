import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/common_methos.dart';
import 'package:pet/controller/data_controller.dart';
import 'package:pet/pages/pet_descreption.dart';
import 'package:pet/pages/pet_add.dart';
import '../components/colors.dart';
import '../configuration/configuration.dart';
import '../controller/model/users_model.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var controller = Get.put(DataController());
  String? selectedCategory;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    saveUserId();
    controller.getUserModel(user!.uid);
    controller.fetchPetDataFromFirestore();
  }

  Future saveUserId() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({'id': user!.uid});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() =>
        AnimatedContainer(
          decoration: controller.isDrawerOpen.value
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                )
              : BoxDecoration(color: Colors.white),
          transform: Matrix4.translationValues(controller.xOffset.value, controller.yOffset.value, 0)
            ..scale(controller.scaleFactor.value),
          duration: Duration(milliseconds: 250),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child:
                  Obx(()=>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.isDrawerOpen.value
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.xOffset.value = 0.0;
                                  controller.yOffset.value = 0.0;
                                  controller.scaleFactor.value = 1.0;
                                  controller.isDrawerOpen.value = false;
                                });
                              },
                              icon: Icon(Icons.arrow_back_ios),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.xOffset.value = 230.0;
                                  controller.yOffset.value = 150.0;
                                  controller.scaleFactor.value = 0.6;
                                  controller.isDrawerOpen.value = true;
                                });
                              },
                              icon: Icon(Icons.menu),
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.paw,
                                color: appColor,
                                size: 19,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'Pet App ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (controller.currentUser != null)
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ProfileScreen());
                            },
                            child: Obx(() {
                              final currentUser = controller.currentUser.value;
                              if (currentUser != null &&
                                  currentUser.imageUrl != null) {
                                return CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(currentUser.imageUrl!),
                                );
                              } else {
                                return CircleAvatar(); // or any other placeholder widget
                              }
                            }),
                          ),
                        ),
                    ],
                  )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18.0),
                        child: SizedBox(
                          height: 50.0,
                          child: TextField(
                            controller: controller.searchTextController,
                            onChanged: (value) {
                              controller.searchTextController.text = value;
                              controller.searchPets(value);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: appColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              hintText: 'Search pet',
                              hintStyle: TextStyle(
                                  letterSpacing: 1, color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: categories.map((e) {
                            var index = categories.indexOf(e);
                            return InkWell(
                              onTap: () {
                                controller.fetchPetDataFromFirestore();
                                controller.selectedCategoryName.value =
                                    e['name'];
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    Obx(() => Container(
                                          padding: EdgeInsets.all(07),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: controller
                                                            .selectedCategoryName
                                                            .value ==
                                                        e['name']
                                                    ? success
                                                    : Colors.transparent,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: shadowList,
                                          ),
                                          child: Image(
                                            image: AssetImage(
                                                categories[index]['imagePath']),
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 07.0,
                                    ),
                                    Text(
                                      categories[index]['name'],
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              // borderRadius: BorderRadius.only(
                              //     topRight: Radius.circular(25),
                              //     topLeft: Radius.circular(25)),
                            ),
                            child: Column(
                              children: [
                                Obx(() => controller.petDataList.isEmpty
                                    ? SizedBox(
                                        height: Get.height,
                                      )
                                    : SizedBox(
                                        height:
                                            controller.petDataList.length <= 2
                                                ? Get.height
                                                : null,
                                        child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          itemCount:
                                              controller.petDataList.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            //database
                                            return GestureDetector(
                                              onTap: () {
                                                if (controller
                                                        .petDataList[index]
                                                        .isSold ==
                                                    true) {
                                                  CommonMethod().getXSnackBar(
                                                      "Error",
                                                      "Sorry,This Pet is sold",
                                                      red);
                                                } else {
                                                  if (user!.email ==
                                                      controller.adminEmail) {
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DescriptionScreen(
                                                                  pet: controller
                                                                          .petDataList[
                                                                      index],
                                                                ))).then(
                                                        (value) {
                                                      controller
                                                          .favoritePetDataList();
                                                      setState(() {});
                                                    });
                                                  }
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    // height: 205,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Stack(
                                                            children: [
                                                              ColorFiltered(
                                                                colorFilter:
                                                                    ColorFilter
                                                                        .mode(
                                                                  controller.petDataList[index].isSold ==
                                                                          true
                                                                      ? grey
                                                                          .withOpacity(
                                                                              .7)
                                                                      : Colors
                                                                          .transparent, // Adjust opacity and grey scale level as needed
                                                                  BlendMode
                                                                      .srcATop,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      180.sp,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: (index %
                                                                                2 ==
                                                                            0)
                                                                        ? Colors.blueGrey[
                                                                            200]
                                                                        : Colors
                                                                            .orangeAccent[200],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    boxShadow:
                                                                        shadowList,
                                                                    //database
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(controller
                                                                          .petDataList[
                                                                              index]
                                                                          .imageLink
                                                                          .toString()),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              35),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 63,
                                                                    bottom: 20),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: controller
                                                                          .petDataList[
                                                                              index]
                                                                          .isSold ==
                                                                      true
                                                                  ? grey
                                                                      .withOpacity(
                                                                          .5)
                                                                  : primaryWhite,
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          50),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              boxShadow:
                                                                  shadowList,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                          .petDataList[
                                                                              index]
                                                                          .name
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20.0,
                                                                        color: Colors
                                                                            .grey[600],
                                                                      ),
                                                                    ),
                                                                    // (catMapList[index]['sex'] == 'male') ? Icon(
                                                                    //   Icons.male_rounded,
                                                                    //   color: Colors.grey[500],
                                                                    // ) :
                                                                    // Icon(
                                                                    //   Icons.female_rounded,
                                                                    //   color: Colors.grey[500],
                                                                    // ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        controller.updatePetDataInFirestore(
                                                                            controller.petDataList[index].id.toString(),
                                                                            controller.petDataList[index],
                                                                            user!.uid);
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: FutureBuilder<
                                                                          bool>(
                                                                        future: controller.isUserIdInFavorite(
                                                                            controller.petDataList[index].id.toString(),
                                                                            user!.uid.toString()),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          return snapshot.data != null && snapshot.data!
                                                                              ? Icon(Icons.favorite, color: Colors.redAccent)
                                                                              : SizedBox();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (controller
                                                                        .petDataList[
                                                                            index]
                                                                        .breed !=
                                                                    null)
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            8.0),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        // Text('Breed :',style: TextStyle(
                                                                        //   fontWeight: FontWeight.bold,
                                                                        //   color: Colors.grey[500],
                                                                        // ),),
                                                                        Expanded(
                                                                          child: Text(
                                                                              controller.petDataList[index].breed.toString(),
                                                                              style: AppTextStyle.normalRegular14.copyWith(color: hintGrey, overflow: TextOverflow.clip)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                if (controller
                                                                            .petDataList[
                                                                                index]
                                                                            .priceText !=
                                                                        null &&
                                                                    user!.email !=
                                                                        controller
                                                                            .adminEmail)
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Price : ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.grey[500],
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        controller
                                                                            .petDataList[index]
                                                                            .priceText
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.green[500],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                if (user!
                                                                        .email ==
                                                                    controller
                                                                        .adminEmail)
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          // Text('Profit : ',   style: TextStyle(
                                                                          //   fontWeight: FontWeight.bold,
                                                                          //   color: Colors.grey[500],
                                                                          // ),),
                                                                          Text(
                                                                            '${controller.petDataList[index].tax ?? "0"}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.green[500],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if (controller
                                                                              .petDataList[
                                                                                  index]
                                                                              .purchaseBy !=
                                                                          null)
                                                                        FutureBuilder<
                                                                            UserModel>(
                                                                          future: controller.getUserModel(controller
                                                                              .petDataList[index]
                                                                              .purchaseBy!),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              // While data is loading
                                                                              return CircularProgressIndicator();
                                                                            } else if (snapshot.hasError) {
                                                                              // If an error occurred
                                                                              return Text('Error: ${snapshot.error}');
                                                                            } else {
                                                                              // If data is successfully loaded
                                                                              final userModel = snapshot.data;
                                                                              // Use the userModel object as needed
                                                                              return Text('User Name: ${userModel!.name}');
                                                                            }
                                                                          },
                                                                        ),
                                                                    ],
                                                                  ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (controller.petDataList[index].isSold ==
                                                                            true) {
                                                                          CommonMethod().getXSnackBar(
                                                                              "Error",
                                                                              "You cannot edit this pet because it has been sold",
                                                                              appColor);
                                                                        } else {
                                                                          Get.to(() =>
                                                                              PetAdd(
                                                                                petModel: controller.petDataList.value[index],
                                                                              ));
                                                                        }
                                                                      },
                                                                      child:
                                                                          Obx(
                                                                        () => controller.petDataList[index].userId ==
                                                                                user!.uid
                                                                            ? Icon(
                                                                                Icons.edit,
                                                                                color: appColor,
                                                                                size: 18,
                                                                              )
                                                                            : SizedBox(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    top: 20,
                                                    left: 0,
                                                    right: 0,
                                                    child: Obx(() => controller
                                                                .petDataList[
                                                                    index]
                                                                .isSold ==
                                                            true
                                                        ? Center(
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          20),
                                                                  child: Text(
                                                                    "Sold",
                                                                    style: AppTextStyle
                                                                        .regularBold
                                                                        .copyWith(
                                                                            color:
                                                                                primaryWhite,
                                                                            fontSize:
                                                                                20),
                                                                  ),
                                                                )),
                                                          )
                                                        : SizedBox()),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),

        if((user!.email !=
            controller.adminEmail))
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: FloatingActionButton(
            onPressed: () async {
              // Get.to(()=>PaymentSuccessDialog());

              Get.to(() => PetAdd())!
                  .then((value) => controller.fetchPetDataFromFirestore());
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
