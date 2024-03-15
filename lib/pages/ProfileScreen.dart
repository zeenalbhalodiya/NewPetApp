import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/buttons/text_button.dart';
import 'package:pet/components/colors.dart';
import 'package:pet/components/static_decoration.dart';
import 'package:pet/controller/data_controller.dart';
import 'package:pet/pages/utils.dart';
import 'package:pet/widget/text_widgets/input_text_field_widget.dart';

import '../controller/model/users_model.dart';
import '../utils/process_indicator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
var controller = Get.put(DataController());

  static Circle processIndicator = Circle();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }


  // Future<void> _getImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  // void _showImagePicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: Icon(Icons.camera),
  //             title: Text('Camera'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _getImage(ImageSource.camera);
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.image),
  //             title: Text('Gallery'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _getImage(ImageSource.gallery);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    refreshPage();
    super.initState();
  }

  Future refreshPage() async{
    await controller.getUserModel(user!.uid);
    if(user!= null){

      if(controller.currentUser != null ){
        _emailController.text = user!.email.toString();
      _nameController.text = controller.currentUser.value!.name.toString();
      _emailController.text = controller.currentUser.value!.email.toString();
      _phoneController.text = controller.currentUser.value!.phone.toString();
      }
    setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Screen',style: AppTextStyle.homeAppbarTextStyle.copyWith(color: primaryWhite),), backgroundColor: appColor,iconTheme: IconThemeData(color: primaryWhite),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Center(
              child: Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundColor: appColor,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : controller.currentUser.value != null &&
                      controller.currentUser.value!.imageUrl != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundColor: appColor,
                    backgroundImage:
                    NetworkImage(controller.currentUser.value!.imageUrl!),
                  )
                      :  CircleAvatar(
                    radius: 64,

                    child: Icon(Icons.person,size: 100,color: primaryWhite,),
                    backgroundColor: appColor,
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,

                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            height20,

            TextFormFieldWidget(controller: _nameController,hintText: "Enter your name",prefixIcon: Icon(Icons.person),),

            height20,
            TextFormFieldWidget(controller: _phoneController,hintText: "Enter your phone",prefixIcon: Icon(Icons.phone),),
            height20,
            TextFormFieldWidget(controller: _emailController,hintText: "Enter your email",prefixIcon: Icon(Icons.email),enabled: false,),
            height20,
            height20,
            height20,
            PrimaryTextButton(title: "Update", onPressed: () async {

              // if(_image != null){
                String? imageUrl;
                processIndicator.show(context);

                if (_image == null) {
                  if(controller.currentUser != null && controller.currentUser.value!.imageUrl != null) {
                    imageUrl = controller.currentUser.value!.imageUrl!;
                  }
                  processIndicator.hide(context);
                } else {
                  imageUrl = await controller.uploadImageToStorage('users', _image!).whenComplete(() {
                    processIndicator.hide(context);
                  });
                }

                controller.updateUser(user: UserModel(id: controller.user!.uid, imageUrl: imageUrl, name: _nameController.text, email: _emailController.text, phone: _phoneController.text, password: null, confirmpassword: null)).then((value) => controller.getUserModel(user!.uid));
            }),
            height20,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}