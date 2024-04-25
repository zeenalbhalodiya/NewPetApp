import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/colors.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],

      child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            // height: Get.height / 1.2,
            child: Lottie.asset('assets/json/nodata.json'),
          ),
          Center(child: Text("No Data Found",style: AppTextStyle.normalBold24.copyWith(color: grey),))
        ],
      ),
    );
  }
}
