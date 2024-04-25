import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_asset.dart';
import 'package:pet/components/buttons/text_button.dart';
import 'package:pet/components/ui.dart';
import 'package:pet/controller/authController.dart';
import 'package:pet/pages/login_screen.dart';
import 'package:pet/widget/auth_title_widget.dart';
import 'package:pet/widget/shadow_container_widget.dart';
import 'package:pet/widget/text_widgets/input_text_field_widget.dart';
import '../components/colors.dart';
import '../components/common_methos.dart';
import '../components/static_decoration.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final controller = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@(?!.*\bname\b)[\w-]+(\.[\w-]+)*\.[a-zA-Z]{2,7}$');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: UiInterface.commonAppBar(leadingWidget: const SizedBox()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  height15,
                  const AuthTitleWidget(
                    title: "Create your Account",
                  ),
                  customHeight(40),
                  TextFormFieldWidget(controller: controller.nameController,hintText: "Name",prefixIcon: Icon(Icons.person,color: Colors.grey[350],),),

                  height16,
                  EmailWidget(
                    controller: controller.emailController,
                    hintText: "Email",
                  ),
                  height16,
                  TextFormFieldWidget(controller: controller.phoneController,hintText: "Phone Number",prefixIcon: Icon(Icons.phone,color: Colors.grey[350],),),
                  height16,
                  PasswordWidget(
                    controller: controller.passwordController,
                    // validator: CommonMethod().passwordValidator,
                    hintText: "Password",
                  ),
                  height16,
                  PasswordWidget(
                    controller: controller.confirmPasswordController,
                    // validator: CommonMethod().passwordValidator,
                    hintText: "Confirm Password",
                  ),
                  customHeight(50),
                  // appButton("Forgot password?", onTap: () {
                  //   Get.to(() => const ForgetPasswordScreen());
                  // }),
                  customHeight(30),
                  PrimaryTextButton(
                    onPressed: () {

                      if (controller.emailController.text.isEmpty) {
                        CommonMethod()
                            .getXSnackBar('Error', 'Please enter email', red);
                      } else if (!emailRegex
                          .hasMatch(controller.emailController.text)) {
                        CommonMethod().getXSnackBar(
                            'Error', 'Please enter valid email', red);
                      } else if (controller.passwordController.text.isEmpty) {
                        CommonMethod().getXSnackBar(
                            'Error', 'Please enter password', red);
                      } else if (controller
                          .confirmPasswordController.text.isEmpty) {
                        CommonMethod().getXSnackBar(
                            'Error', 'Please enter confirm password', red);
                      } else if (controller.passwordController.text !=
                          controller.confirmPasswordController.text) {
                        CommonMethod().getXSnackBar(
                            'Error', 'Passwords do not match!', red);
                      } else {
                        controller.registerWithEmailAndPassword(context);
                      }
                    },
                    title: "Sign Up",
                  ),
                  customHeight(25),
                  const OrWidget(),
                  customHeight(25),
                  GestureDetector(
                    onTap: () {
                      controller.handleSignInGoogle();
                    },
                    child: ShadowContainerWidget(
                        padding: 0,
                        widget: SizedBox(
                          height: 50,
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppAsset.icGoogle),
                              width10,
                              Text('Sign Up with Google')
                            ],
                          ),
                        )),
                  ),
                  // ImageButton(
                  //   onPressed: () {
                  //    controller.loginWithGoogle(context);
                  //  },
                  //   buttonName: 'Login With Google',
                  //   imageLink: AppAsset.icGoogle,
                  //  ),
                  customHeight(30),
                  AuthDontHaveAccountWidget(
                    buttonText: "Log in",
                    title: "Already have an account?",
                    onTap: () {
                      // CommonMethod().goToLoginScreen();
                      Get.to(() => const LoginScreen());
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// InputTextFieldWidget
class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final String? Function(String?)? validator;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const InputTextFieldWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    this.validator,
    this.textStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon,  color: iconColor),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          border: InputBorder.none,
      ),
      validator: validator,
      style: textStyle,
      ),
    );
  }
}
