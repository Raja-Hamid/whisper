import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 45.w,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Whisper',
                  style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: CustomColors.primaryColor1,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.videocam,
              color: CustomColors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.call,
                color: CustomColors.white,
              ),
            ),
          ),
        ],
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
                Colors.white.withAlpha((0.8 * 255).round()),
              ],
              stops: const [0, 0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0.r),
              topRight: Radius.circular(40.0.r),
            ),
          ),
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.emoji_emotions),
                        hintText: 'Message',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: CustomColors.primaryColor1,
                    child: Icon(
                      Icons.send,
                      color: CustomColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
