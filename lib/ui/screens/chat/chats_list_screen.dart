import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/screens/chat/add_friends_screen.dart';
import 'package:whisper/ui/widgets/chat_tile.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Whisper',
          style: TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 35.sp,
            fontFamily: 'PlayFairDisplay',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              child: CircleAvatar(
                radius: 20.r,
              ),
              onTap: () => Get.toNamed(AppPages.profileScreen),
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
                SearchBar(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 15.w),
                  ),
                  hintText: 'Search',
                  leading: const Icon(Icons.search),
                  backgroundColor: WidgetStatePropertyAll(CustomColors.white),
                ),
                SizedBox(
                  height: 25.h,
                ),
                GestureDetector(
                  child: const ChatTile(
                      name: 'Knight',
                      message: 'Hello',
                      time: '07:05 pm',
                      unreadMessages: 2,
                      avatarUrl: ''),
                  onTap: () {
                    Get.toNamed(AppPages.chatScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(const AddFriendsScreen()),
      ),
    );
  }
}
