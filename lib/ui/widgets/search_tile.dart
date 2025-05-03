import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  final String userName;
  const SearchTile({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.r,
        ),
        title: Text(userName),
      ),
    );
  }
}
