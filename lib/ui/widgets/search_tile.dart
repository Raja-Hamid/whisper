import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  final String userName;
  final Function()? onPressed;
  const SearchTile(
      {super.key, required this.userName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.r,
        ),
        title: Text(userName),
        trailing:
            TextButton(onPressed: onPressed, child: const Text('Add Friend')),
      ),
    );
  }
}
