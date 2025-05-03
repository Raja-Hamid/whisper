import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadMessages;
  final String avatarUrl;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadMessages,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
       shape: BoxShape.circle,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            backgroundColor:
                avatarUrl.isEmpty ? Colors.blueAccent : Colors.transparent,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.black),
              ),
              if (unreadMessages > 0)
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
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
            ],
          ),
        ],
      ),
    );
  }
}
