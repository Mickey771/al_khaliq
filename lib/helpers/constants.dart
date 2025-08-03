
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF000000);
const lightBlueColor = Color(0xFF89CFF0);

const gradientColors = [
  Color(0xFF191E31),
  Color(0xFF10121f),
  Color(0xFF350E47),
  Color(0xFF66809A),
  Color(0xFF293b49),
];

const double appBarHeight = 60;
const double adminAppBarHeight = 80;


smallHSpace() => const SizedBox(width: 20);
tinyHSpace() => const SizedBox(width: 10);
smallSpace() => const SizedBox(height: 20);
tinySpace() => const SizedBox(height: 10);
tiny15Space() => const SizedBox(height: 15);
tiny5Space() => const SizedBox(height: 5);
tinyH5Space() => const SizedBox(width: 5);
mediumSpace() => const SizedBox(height: 30);
mediumHSpace() => const SizedBox(width: 30);


double height() => Get.height;
double width() => Get.width;

Widget kSpacing =  const SizedBox(height: 10,);
Widget kLargeSpacing =  const SizedBox(height: 30,);

verticalSpace(factor) => SizedBox(height: height() * factor);
horizontalSpace(factor) => SizedBox(width: width() * factor);

Widget subText(title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15),
    ),
  );
}



TextStyle ralewayTextFont = GoogleFonts.roboto(
    fontSize: 15.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500
);

TextStyle exconTextFont = TextStyle(
  fontFamily: 'Excon',
    fontSize: 15.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500
);


TextStyle outfitTextFont = GoogleFonts.outfit(
    fontSize: 15.sp,
    color: Colors.black,
    fontWeight: FontWeight.w600
);

LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF003049).withOpacity(0), Color(0xFF003049).withOpacity(0.9)
    ],
    stops: [0.0,  0.56],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    tileMode: TileMode.repeated
);

const String emptyEmailField = 'Email field cannot be empty!';
const String emptyTextField = 'Field cannot be empty!';
const String emptyPasswordField = 'Password field cannot be empty';
const String invalidEmailField =
    "Email provided isn\'t valid.Try another email address";
const String passwordLengthError = 'Password length must be greater than 6';
const String emptyUsernameField = 'Name cannot be empty';
const String usernameLengthError = 'Username length must be greater than 5';
const String emailRegex = '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}' +
    '\\@' +
    '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}' +
    '(' +
    '\\.' +
    '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}' +
    ')+';
const String PHONE_NUMBER_LENGTH_ERROR = 'Phone number must be 11 digits';

const String phoneNumberRegex = r'0[789][01]\d{8}';
const String phoneNumberRegex2 = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
const String upperCaseRegex = r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$';
const String lowerCaseRegex = r'^(?=.*?[a-z]).{8,}$';
const String symbolRegex = r'^(?=.*?[!@#\$&*~]).{8,}$';
const String digitRegex = r'^(?=.*?[0-9]).{8,}$';
const String passwordDigitErr = 'Password must have at least one digit';
const String passwordUppercaseErr = 'Password must have at least one Upper case';
const String passwordSymbolErr = 'Password must have a least one special character';

const String phoneNumberLengthError = 'Phone number must be 11 digits';

const String phoneNumberFormatError = 'Phone number must have the format +1234567890';

const String invalidPhoneNumberField =
    "Number provided isn\'t valid.Try another phone number";
