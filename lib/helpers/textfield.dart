
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

class TextFieldWidget extends StatelessWidget {
  String hint;
  String? label;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Widget? suffix;
  TextEditingController? textController;
  String? Function(String?)? validator;
  Color? backgroundColor;
  bool? enabled;
  bool obscureText;
  double? fieldHeight;
  bool underLine;
  int? maxLine = 1;
  TextInputType? keyboardType;
  ScrollController? scrollController;
  bool? isDropDown;
  TextStyle? textStyle;
  Function()? onTap;

    TextFieldWidget(
      {Key? key,
        required this.hint,
        this.label,
        this.prefixIcon,
        this.suffixIcon,
        this.suffix,
        this.obscureText = false,
        this.enabled,
        this.maxLine = 1,
        this.fieldHeight,
        this.textController,
        this.keyboardType,
        this.scrollController,
        this.backgroundColor,
        this.underLine = false,
        this.validator,
        this.textStyle,
        this.isDropDown,
        this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fieldHeight == null ? ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height() * 0.5,
      ),

      child: TextFormField(
        style: TextStyle(
            fontSize: 13.sp,
            color: whiteColor,
            fontWeight: FontWeight.w500
        ),
        onTap: onTap,
        maxLines: maxLine == null ? null : maxLine,
        enabled: enabled,
        scrollPhysics: ClampingScrollPhysics(),
        keyboardType: keyboardType,
        validator: validator,
        autocorrect: false,
        scrollController: scrollController,
        controller: textController,
        obscureText: obscureText,
        enableInteractiveSelection: true,
        cursorColor: blackColor,
        decoration: InputDecoration(
          fillColor:  backgroundColor ?? Color(0xFFF6F6F6),
          filled: true,
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(70.sp),
              borderSide: BorderSide(color: underLine == true ? Color(0xFF003049) : Colors.transparent)),
          disabledBorder: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(70.sp),
              borderSide: BorderSide(color: underLine == true ? Color(0xFF003049) : Colors.transparent)),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(color: Colors.red),
          contentPadding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 15.sp),
          hintText: hint,
          // labelText: hint,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Color(0xFF828282),
            fontWeight: FontWeight.w400,
          ),
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 16.sp, color: Colors.grey.shade400),
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
        ),
      ),
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!,
        style: TextStyle(
          fontSize: 13.sp,
          color: whiteColor
        ),),
        Container(
          height: fieldHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.sp),
            color:  backgroundColor ?? Color(0xFFF6F6F6),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height() * 0.5,
            ),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 12.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w500
              ),
              onTap: onTap,
              maxLines: maxLine == null ? null : maxLine,
              enabled: enabled,
              scrollPhysics: ClampingScrollPhysics(),
              keyboardType: keyboardType,
              validator: validator,
              autocorrect: false,
              scrollController: scrollController,
              controller: textController,
              obscureText: obscureText,
              enableInteractiveSelection: true,
              cursorColor: whiteColor,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: underLine == true ? Color(0xFF003049) : Colors.transparent)),
                disabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: underLine == true ? Color(0xFF003049) : Colors.transparent)),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: TextStyle(color: Colors.red),
                contentPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                hintText: hint,
                // labelText: hint,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: whiteColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade400),
                prefixIcon: prefixIcon,
                suffix: suffix,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}