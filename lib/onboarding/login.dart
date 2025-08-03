import 'dart:async';

import 'package:al_khaliq/onboarding/sign_up.dart';
import 'package:al_khaliq/screens/home.dart';
import 'package:al_khaliq/screens/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../helpers/constants.dart';
import '../../helpers/validator.dart';
import '../controllers/account_controller.dart';
import '../helpers/textfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final _formKey = GlobalKey<FormState>();

  AccountController accountController = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    // loadApp();
    super.initState();
  }

  RxBool visible = false.obs;


  // loadApp() async {
  //   Timer(
  //       const Duration(seconds: 2),
  //           () =>  _firebaseMethods.signInAnonymously()
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Color(0xFF10121f),

      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [

          Positioned(
              top: 70,
              left: -50,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 150,
                        spreadRadius: 0,
                        color: Color(0xFF220b56),
                        // color: Colors.red
                      )
                    ]
                ),
              )
          ),

          Positioned(
              top: 300,
              right: -80,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 170,
                        spreadRadius: 0,
                        color: Color(0xFF584171),
                      )
                    ]
                ),
              )
          ),

          Positioned(
              bottom: -50,
              right: 90,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 180,
                        spreadRadius: 0,
                        color: Color(0xFF47687d),
                      )
                    ]
                ),
              )
          ),



          GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.sp, 60.sp, 20.sp, 30.sp),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                  
                  
                  
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                  
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                      child: Icon(Icons.arrow_back_ios_new, color: whiteColor),)),
                  
                              verticalSpace(0.02),
                              Image.asset('assets/images/assetImages/SignUpHeader.png', fit: BoxFit.cover, scale: 4,),
                              verticalSpace(0.03),
                  
                              Text('Login to Your Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 19.sp,
                                      height: 1.4,
                                      fontWeight: FontWeight.w700,
                                      color: whiteColor
                                  )),
                  
                  
                              verticalSpace(0.02),
                  
                  
                  
                  
                              TextFieldWidget(
                                hint: "Enter your email",
                                label: "E-mail",
                                maxLine: 1,
                                fieldHeight: 50.sp,
                                backgroundColor: Color(0xFF10121f).withOpacity(0.35),
                                textController: accountController.email,
                                prefixIcon:  Icon(Icons.mail, color: whiteColor.withOpacity(0.8),),
                                validator: (value) => EmailValidator.validate(value!),
                              ),
                  
                              verticalSpace(0.02),
                  
                              Obx(() =>  TextFieldWidget(
                                hint: "Enter your password",
                                label: "Password",
                                maxLine: 1,
                                fieldHeight: 50.sp,
                                backgroundColor: Color(0xFF10121f).withOpacity(0.35),
                                textController: accountController.password,
                                obscureText: visible.value,
                                suffixIcon: visible.value == false ?
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: (){
                                    visible.value = true;
                                  },
                                  child: Icon(FontAwesomeIcons.eye, size: 17.sp, color: whiteColor.withOpacity(0.7),),
                                ) :
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: (){
                                    visible.value = false;
                                  },
                                  child: Icon(FontAwesomeIcons.eyeSlash, size: 17.sp, color: whiteColor.withOpacity(0.7),),
                                ) ,
                  
                                // validator: (value) => PasswordValidator.validate(value!),
                              ),),
                  
                              verticalSpace(0.03),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Forgot Password?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor
                                    )),
                              ),
                  
                              verticalSpace(0.04),
                  
                  
                              Obx(() =>InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: (){
                  
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    accountController.loadingStatus.value == true ? (){}
                                        : accountController.signIn(context: context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.sp, ),
                                  decoration: BoxDecoration(
                                    color:  Color(0xFF10121f).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(7.sp),
                                  ),
                                  child: Center(
                                    child: accountController.loadingStatus.value == true ? LoadingAnimationWidget.stretchedDots(color: Colors.white, size: 20)
                                        : Text("Login",
                                        textAlign: TextAlign.center,
                                        style: ralewayTextFont.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: whiteColor
                                        )),
                                  ),
                                ),
                              ),),
                  
                              verticalSpace(0.03),
                  
                  
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don’t have an account yet? ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: lightBlueColor
                                      )),
                                  InkWell(
                                    onTap: (){
                                        Get.to(() => SignUp());
                                    },
                                    child: Text(" Sign Up!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w700,
                                            color: whiteColor
                                        )),
                                  ),
                                ],
                              )
                  
                            ],
                          ),
                  
                  
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),


        ],
      ),
    );
  }
}
