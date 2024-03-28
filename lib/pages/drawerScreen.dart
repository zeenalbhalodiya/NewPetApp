import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/components/static_decoration.dart';
import 'package:pet/controller/authController.dart';
import 'package:pet/pages/PaymentDetailsScreen.dart';
import 'package:pet/pages/contactus.dart';
import 'package:pet/pages/reports_page.dart';
import 'package:pet/pages/wishlist_screen.dart';
import '../configuration/configuration.dart';
import 'package:pet/pages/pet_add.dart';
import '../controller/data_controller.dart';
import 'admin_dashboard_screen.dart';
import 'main_home_page.dart';

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
          height05,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CircleAvatar(),

      width15,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() =>
          Text(
            controller.currentUser.value != null ? controller.currentUser.value!.name ?? user!.displayName! : "UnKnown",
            style: AppTextStyle.normalBold18.copyWith(color: primaryWhite),
          ),
          ),

              Text(
                "Active User",
                style: AppTextStyle.normalBold18.copyWith(color: primaryWhite),
          ),

        ],
      )
            ],
          ),

          user!.email ==
              controller.adminEmail ?
          Column(
            children: drawerItemsForAdmin
                .map((element) => GestureDetector(
              onTap: () {
                if (element['title'] == 'Logout') {
                  _showLogoutDialog(context);
                } else if (element['title'] == 'Sold Pet') {
                  controller.xOffset.value = 0.0;
                  controller.yOffset.value = 0.0;
                  controller.scaleFactor.value = 1.0;
                  controller.isDrawerOpen.value = false;
controller.update();
// Get.to(()=>HomePage());
                } else if (element['title'] == 'Dashboard') {
Get.to(()=>AdminDashboardPage());
                } else if (element['title'] == 'Reports') {
                  Get.to(()=>BarChartSample2());
                  // Get.to(()=>WeeklyAnalysis());

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
                            fontSize: 20),),
                  ],
                ),
              ),
            ))
                .toList(),

          ): Column(
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
                          fontSize: 20),),
                  ],
                ),
              ),
            ))
                .toList(),

          ),
          SizedBox(),
          SizedBox(),
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
