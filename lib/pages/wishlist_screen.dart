import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/pages/pet_descreption.dart';

import '../components/colors.dart';
import '../configuration/configuration.dart';
import '../controller/data_controller.dart';

class WishListScreen extends StatefulWidget {
  final Key? key;
  const WishListScreen({this.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  var controller = Get.put(DataController());
  @override
  void initState() {
    super.initState();
    controller.fetchPetDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite'), backgroundColor: appColor,),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                physics: ScrollPhysics(),
                itemCount: controller.favoritePetDataList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  //database
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DescriptionScreen(
                                    pet: controller
                                        .favoritePetDataList[index],
                                  )));
                    },
                    child: Container(
                      height: 230,
                      margin:
                      EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: (index % 2 == 0)
                                        ? Colors.blueGrey[200]
                                        : Colors
                                        .orangeAccent[200],
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    boxShadow: shadowList,
                                    //database
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          controller
                                              .favoritePetDataList[index]
                                              .imageLink
                                              .toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  margin:
                                  EdgeInsets.only(top: 40),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 65, bottom: 20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight:
                                    Radius.circular(20)),
                                boxShadow: shadowList,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
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
                                            .favoritePetDataList[index]
                                            .name
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 21.0,
                                          color: Colors.grey[600],
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
                                    ],
                                  ),
                                  Text(
                                    controller
                                        .favoritePetDataList[index].price
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    controller.favoritePetDataList[index].breed.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      // Icon(
                                      //   Icons.location_on,
                                      //   color: appColor,
                                      //   size: 18,
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
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
