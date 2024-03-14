import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/controller/authController.dart';
import 'package:pet/pages/PaymentDetailsScreen.dart';
import 'package:pet/pages/contactus.dart';
import 'package:pet/pages/wishlist_screen.dart';
import '../configuration/configuration.dart';
import 'package:pet/pages/pet_add.dart';
import '../controller/data_controller.dart';
import '../controller/model/users_model.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  var controller = Get.put(DataController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColor,
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // CircleAvatar(),
              SizedBox(
                width: 10,
              ),

              FutureBuilder<UserModel>(
                future: controller.getUserModel(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    UserModel userModel = snapshot.data!;
                    // Now you can use the userModel in your UI
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.name ?? user!.displayName!,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 3),
                        ),
                        Text(
                          userModel.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        // Text( userModel.phone ?? user!.phoneNumber!,
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 20,
                        //         height: -2))
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the WishlistPage
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => wishlist()),
              // );
            },
            child: Column(
              children: drawerItems
                  .map((element) => GestureDetector(
                onTap: () {
                  print("----------test-------");
                  if (element['title'] == 'Logout') {
                    _showLogoutDialog(context);
                  } else if (element['title'] == 'Add Pet') {
                    Get.to(()=>PetAdd());

                  } else if (element['title'] == 'Favourite') {
                    // Handle favorite icon tap event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishListScreen()),
                    );
                  } else if (element['title'] == 'Contact Us') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsPage()),
                    );
                  }else if(element['title'] =='Transactions'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentDetailsScreen()),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        element['icon'],
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(element['title'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))
                    ],
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          Row(
            children: [
              Icon(Icons.settings, color: Colors.white),
              SizedBox(
                width: 10,
                height: 20,
              ),
              Text(
                'Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                width: 10,
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and perform logout action
                // Navigator.of(context).pop();
                var controller = Get.put(AuthController());
                controller.signOut();
                // Add your logout logic here
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
