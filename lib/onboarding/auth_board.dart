
import 'package:al_khaliq/controllers/genre_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/onboarding/login.dart';
import 'package:al_khaliq/onboarding/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../helpers/constants.dart';
import '../controllers/account_controller.dart';

class AuthBoard extends StatefulWidget {
  const AuthBoard({super.key});

  @override
  State<AuthBoard> createState() => _AuthBoardState();
}

class _AuthBoardState extends State<AuthBoard> {
  //final _formKey = GlobalKey<FormState>();

  AccountController accountController = Get.put(AccountController());
  MusicController musicController = Get.put(MusicController());
  PlaylistController playlistController = Get.put(PlaylistController());
  GenreController genreController = Get.put(GenreController());
  UserController userController = Get.put(UserController());

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
        color: Color(0xFF10121f),
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
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 150,
                    spreadRadius: 0,
                    color: Color(0xFF220b56),
                    // color: Colors.red
                  )
                ]),
              )),
          Positioned(
              top: 300,
              right: -80,
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 170,
                    spreadRadius: 0,
                    color: Color(0xFF584171),
                  )
                ]),
              )),
          Positioned(
              bottom: -50,
              right: 90,
              child: Container(
                height: 300,
                width: 300,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 180,
                    spreadRadius: 0,
                    color: Color(0xFF47687d),
                  )
                ]),
              )),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                  padding: EdgeInsets.fromLTRB(20.sp, 60.sp, 20.sp, 30.sp),
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
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(
                                      Icons.arrow_back_outlined,
                                      color: Color(0xFF003049),
                                    ))),

                            Image.asset(
                              'assets/images/assetImages/SignUpHeader.png',
                              fit: BoxFit.cover,
                              scale: 4,
                            ),
                            verticalSpace(0.03),

                            Text('Join Al-Khaliq Community Today!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    height: 1.4,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor)),

                            // TextFieldWidget(
                            //   hint: "E-mail",
                            //   maxLine: 1,
                            //   textController: accountController.email,
                            //   prefixIcon:  Image.asset('assets/images/icons/mail.png', scale: 35.sp,),
                            //   validator: (value) => EmailValidator.validate(value!),
                            // ),
                            //
                            // verticalSpace(0.02),
                            //
                            // Obx(() =>  TextFieldWidget(
                            //   hint: "Password",
                            //   maxLine: 1,
                            //   textController: accountController.password,
                            //   obscureText: visible.value,
                            //   prefixIcon:  Image.asset('assets/images/icons/password.png', scale: 25.sp,),
                            //   suffixIcon: visible.value == false ?
                            //   InkWell(
                            //     onTap: (){
                            //       visible.value = true;
                            //     },
                            //     child: Image.asset('assets/images/icons/eye.png', scale: 30.sp,),
                            //   ) :
                            //   InkWell(
                            //     onTap: (){
                            //       visible.value = false;
                            //     },
                            //     child: Padding(
                            //       padding: EdgeInsets.only(right: 16.sp),
                            //       child: Icon(Icons.remove_red_eye),
                            //     ),
                            //   ) ,
                            //
                            //   validator: (value) => PasswordValidator.validate(value!),
                            // ),),

                            verticalSpace(0.03),

                            Obx(
                              () => InkWell(
                                onTap: () {
                                  accountController.signInWithGoogle(
                                      context: context);
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 16, 30, 16),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 43.sp),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(70.sp),
                                  ),
                                  child: Center(
                                    child: accountController
                                                .loadingStatus.value ==
                                            true
                                        ? LoadingAnimationWidget.stretchedDots(
                                            color: Colors.white, size: 20)
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/images/icons/Google.png',
                                                fit: BoxFit.scaleDown,
                                                scale: 22,
                                              ),
                                              Text("Sign up with Google",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)),
                                              horizontalSpace(0.005),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            verticalSpace(0.02),

                            Obx(
                              () => InkWell(
                                onTap: () {
                                  accountController.signInWithApple(
                                      context: context);
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 16, 30, 16),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 43.sp),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(70.sp),
                                  ),
                                  child: Center(
                                    child: accountController
                                                .loadingStatus.value ==
                                            true
                                        ? LoadingAnimationWidget.stretchedDots(
                                            color: Colors.white, size: 20)
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/images/icons/Apple.png',
                                                fit: BoxFit.scaleDown,
                                                scale: 22,
                                              ),
                                              Text("Sign up with Apple",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)),
                                              horizontalSpace(0.005),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),

                            verticalSpace(0.02),

                            Obx(
                              () => InkWell(
                                onTap: () {
                                  Get.to(() => SignUp());
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 16, 30, 16),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 43.sp),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(70.sp),
                                  ),
                                  child: Center(
                                    child: accountController
                                                .loadingStatus.value ==
                                            true
                                        ? LoadingAnimationWidget.stretchedDots(
                                            color: Colors.white, size: 20)
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/images/icons/Email.png',
                                                fit: BoxFit.scaleDown,
                                                scale: 22,
                                              ),
                                              Text("Sign up with Email",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)),
                                              horizontalSpace(0.005),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            verticalSpace(0.014),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => Login());
                                  },
                                  child: Text(" Sign in",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: whiteColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "By registering, you confirm that you accept our\n\n",
                              children: [
                                TextSpan(
                                    text: "Terms of Use ",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                                TextSpan(text: "and "),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor))
                              ],
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor)),
                        )
                      ])),
            ),
          ),
        ],
      ),
    );
  }
}
