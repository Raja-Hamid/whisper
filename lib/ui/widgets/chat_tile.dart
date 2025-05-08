import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadMessages;
  final String avatar;
  // final String avatarUrl;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadMessages,
    required this.avatar,
    // required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            child: Text(
              avatar,
              style: const TextStyle(fontSize: 23),
            ),
            // backgroundImage:
            //     avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            // backgroundColor:
            //     avatarUrl.isEmpty ? Colors.blueAccent : Colors.transparent,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Text(
                        time,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message,
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (unreadMessages > 0)
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            unreadMessages.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
