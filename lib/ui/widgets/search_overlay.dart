import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/controllers/friends_controller.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  final FriendController _friendController = Get.find();

  List<String> recentSearches = ['john_doe', 'alice123', 'coolguy'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _friendController.setSearchQuery(_searchController.text);
    });
  }

  void addRecentSearch(String query) {
    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 10) {
          recentSearches = recentSearches.sublist(0, 10); // Max 10
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 1.0,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.only(top: 50.h, left: 15.w, right: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _friendController.setSearchQuery('');
                    },
                  ),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 15.h),
              Obx(() {
                final query = _friendController.searchQuery.value;
                final users = _friendController.searchedUserList;

                if (query.isEmpty) {
                  return Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        Text('Recent Searches',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        ...recentSearches.map((search) => ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(search),
                              onTap: () {
                                _searchController.text = search;
                                _friendController.setSearchQuery(search);
                              },
                            )),
                      ],
                    ),
                  );
                }

                if (users.isEmpty) {
                  return const Expanded(
                      child: Center(child: Text("No users found.")));
                }

                return Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemCount: users.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          radius: 20.r,
                        ),
                        title: Text(user.userName),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _friendController.sendFriendRequest(user.uid);
                            addRecentSearch(user.userName);
                          },
                          child: const Text('Add'),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
