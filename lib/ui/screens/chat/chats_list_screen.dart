import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/auth_controller.dart';
import 'package:whisper/controllers/chat_controller.dart';
import 'package:whisper/controllers/friend_request_controller.dart';
import 'package:whisper/models/chat_preview_model.dart';
import 'package:whisper/routes/app_pages.dart';
import 'package:whisper/ui/screens/chat/add_friends_screen.dart';
import 'package:whisper/ui/widgets/background_gradient.dart';
import 'package:whisper/ui/widgets/chat_tile.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final FriendRequestController _friendRequestController =
      Get.put(FriendRequestController());
  final ChatController _chatController = Get.put(ChatController());

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

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
              child: Obx(
                () {
                  final user = _authController.userModel.value;
                  if (user == null) {
                    return CircleAvatar(
                      radius: 20.r,
                    );
                  }
                  return CircleAvatar(
                    radius: 20.r,
                    child: Text(
                      user.firstName[0],
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  );
                },
              ),
              onTap: () => Get.toNamed(AppPages.profileScreen),
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight,
      ),
      body: BackgroundGradient(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  child: SearchBar(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 15.w),
                    ),
                    hintText: 'Search',
                    leading: const Icon(Icons.search),
                    backgroundColor: WidgetStatePropertyAll(CustomColors.white),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _friendRequestController.getFriendsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No friends yet.'));
                      }

                      final friends = snapshot.data!;
                      final currentUserId = _authController.userModel.value!.uid;

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];

                          return StreamBuilder<ChatPreview>(
                            stream: _chatController.getChatPreview(
                              currentUserId: currentUserId,
                              friendUserId: friend.uid,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              }

                              final preview = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(
                                    AppPages.chatScreen,
                                    arguments: friend,
                                  ),
                                  child: ChatTile(
                                    name: '${friend.firstName} ${friend.lastName}',
                                    message: preview.message,
                                    time: _formatTimestamp(preview.timestamp),
                                    unreadMessages: 0,
                                    avatar: friend.firstName[0],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
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