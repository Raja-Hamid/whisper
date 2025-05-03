import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Add Friends',
          style: TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75.h,
        iconTheme: IconThemeData(color: CustomColors.white, size: 25.sp),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CustomColors.bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 100.h),
          padding: EdgeInsets.fromLTRB(10.0.w, 25.0.h, 10.0.w, 25.0.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withAlpha((0.5 * 255).round()),
              ],
              stops: const [0, 0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.r),
              topRight: Radius.circular(40.0.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search for users',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 25.h,),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
