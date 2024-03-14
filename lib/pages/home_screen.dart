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
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  var controller = Get.put(DataController());
  String? selectedCategory;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    controller.fetchPetDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          decoration: isDrawerOpen
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                )
              : BoxDecoration(color: Colors.white),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          duration: Duration(milliseconds: 250),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isDrawerOpen
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    scaleFactor = 1;
                                    isDrawerOpen = false;
                                  });
                                },
                                icon: Icon(Icons.arrow_back_ios),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 230;
                                    yOffset = 150;
                                    scaleFactor = 0.6;
                                    isDrawerOpen = true;
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
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage('images/pet_cat.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
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
                                suffixIcon: Icon(
                                  Icons.tune_sharp,
                                  color: Colors.grey[400],
                                ),
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
                                                  categories[index]
                                                      ['imagePath']),
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
                        Obx(() => controller.petDataList.isEmpty
                            ? SizedBox(
                                height: Get.height,
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: controller.petDataList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  //database
                                  return GestureDetector(
                                    onTap: () {
                                      if (controller
                                              .petDataList[index].isSold ==
                                          true) {
                                        CommonMethod().getXSnackBar("Error",
                                            "Sorry,This Pet is sold", red);
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
                                                            .petDataList[index],
                                                      ))).then((value) {
                                            controller.favoritePetDataList();
                                            setState(() {});
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      // height: 205,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 180.sp,
                                                  decoration: BoxDecoration(
                                                    color: (index % 2 == 0)
                                                        ? Colors.blueGrey[200]
                                                        : Colors
                                                            .orangeAccent[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    boxShadow: shadowList,
                                                    //database
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          controller
                                                              .petDataList[
                                                                  index]
                                                              .imageLink
                                                              .toString()),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(top: 35),
                                                ),
                                                Obx(() => controller
                                                            .petDataList[index]
                                                            .isSold ==
                                                        true
                                                    ? Positioned(
                                                        top: 16,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .redAccent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                              child: Text(
                                                                "Sold",
                                                                style: AppTextStyle
                                                                    .regularBold
                                                                    .copyWith(
                                                                        color:
                                                                            primaryWhite),
                                                              ),
                                                            )),
                                                      )
                                                    : SizedBox())
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 63, bottom: 20),
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(50),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                                boxShadow: shadowList,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .petDataList[index]
                                                            .name
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                          color:
                                                              Colors.grey[600],
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
                                                        onTap: () {
                                                          controller.updatePetDataInFirestore(
                                                              controller
                                                                  .petDataList[index].id.toString(),
                                                              controller.petDataList[index],
                                                              user!.uid);
                                                          setState(() {});
                                                        },
                                                        child:
                                                            FutureBuilder<bool>(
                                                          future: controller
                                                              .isUserIdInFavorite(
                                                                  controller
                                                                      .petDataList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  user!.uid
                                                                      .toString()),
                                                          builder: (context,
                                                              snapshot) {
                                                            return snapshot.data !=
                                                                        null &&
                                                                    snapshot
                                                                        .data!
                                                                ? Icon(
                                                                    Icons.favorite,
                                                                    color: Colors.redAccent)
                                                                : SizedBox();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (controller
                                                          .petDataList[index]
                                                          .breed !=
                                                      null)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
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
                                                                controller
                                                                    .petDataList[
                                                                        index]
                                                                    .breed
                                                                    .toString(),
                                                                style: AppTextStyle
                                                                    .normalRegular14
                                                                    .copyWith(
                                                                        color:
                                                                            hintGrey,
                                                                        overflow:
                                                                            TextOverflow.clip)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (controller.petDataList[index].priceText != null &&
                                                      user!.email != controller.adminEmail)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Price : ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                        Text(
                                                          controller
                                                              .petDataList[
                                                                  index]
                                                              .priceText
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .green[500],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  if (user!.email ==
                                                      controller.adminEmail)
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
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .green[500],
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
                                                            future: controller
                                                                .getUserModel(controller.petDataList[index].purchaseBy!),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                // While data is loading
                                                                return CircularProgressIndicator();
                                                              } else if (snapshot
                                                                  .hasError) {
                                                                // If an error occurred
                                                                return Text(
                                                                    'Error: ${snapshot.error}');
                                                              } else {
                                                                // If data is successfully loaded
                                                                final userModel =
                                                                    snapshot
                                                                        .data;
                                                                // Use the userModel object as needed
                                                                return Text(
                                                                    'User Name: ${userModel!.name}');
                                                              }
                                                            },
                                                          ),
                                                        Row(
                                                          children: [
                                                            // Text('Per.By : ',   style: TextStyle(
                                                            //   fontWeight: FontWeight.bold,
                                                            //   color: Colors.grey[500],
                                                            // ),),
                                                            // Text(
                                                            //   controller.petDataList[index].tax.toString(),
                                                            //   style: TextStyle(
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold,
                                                            //     color: Colors
                                                            //         .green[500],
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                  // Text(
                                                  //   (controller.petDataList[index].age ?? 'Unknown') + ' years old',
                                                  //   style: TextStyle(
                                                  //     fontSize: 10,
                                                  //     color: Colors.grey[400],
                                                  //   ),
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: appColor,
                                                        size: 18,
                                                      ),

                                                      // GestureDetector(
                                                      //   onTap: () {
                                                      //     controller.updatePetDataInFirestore(
                                                      //         controller.petDataList[index].id.toString(), controller.petDataList[index], user!.uid);
                                                      //     setState(() {});
                                                      //   },
                                                      //   child: FutureBuilder<bool>(
                                                      //     future: controller.isUserIdInFavorite(
                                                      //         controller.petDataList[index].id.toString(), user!.uid.toString()),
                                                      //     builder: (context, snapshot) {
                                                      //       return
                                                      //         snapshot.data!=null && snapshot.data! ?
                                                      //
                                                      //         Icon( Icons.favorite,
                                                      //             color: Colors.redAccent):SizedBox();
                                                      //     },
                                                      //   ),
                                                      // ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      // Text(
                                                      //   'Distance: '+catMapList[index]['distance'],
                                                      //   style: TextStyle(
                                                      //     fontWeight: FontWeight.bold,
                                                      //     color: Colors.grey[400],
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: FloatingActionButton(
            onPressed: () async {
              // Navigate to the 'pet_add' page

              Get.to(() => PetAdd())!
                  .then((value) => controller.fetchPetDataFromFirestore());
              // var result = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PetAdd(),
              //   ),
              // );
              // if (result != null && result) {
              //   controller.fetchPetDataFromFirestore();
              // }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PetAdd(),
              //   ),
              // ).then((value) => controller.fetchPetDataFromFirestore());
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
