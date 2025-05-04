import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/controllers/friend_request_controller.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/ui/widgets/search_tile.dart';
import 'package:whisper/controllers/user_search_controller.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final UserSearchController _searchController = UserSearchController();
  final FriendRequestController _friendRequestController =
      Get.put(FriendRequestController());
  List<UserModel> localSearchResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _friendRequestController.fetchRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> handleSearch(String query) async {
    final results = await _searchController.searchUsers(query);
    setState(() => localSearchResults = results);
  }

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
        width: double.infinity,
        height: double.infinity,
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
                CustomColors.white.withAlpha((0.5 * 255).round()),
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
                SearchAnchor.bar(
                  barPadding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 15.w),
                  ),
                  barHintText: 'Search for users',
                  barLeading: const Icon(Icons.search),
                  barBackgroundColor:
                      WidgetStatePropertyAll(CustomColors.white),
                  onChanged: (query) => handleSearch(query),
                  suggestionsBuilder: (context, controller) {
                    if (controller.text.isEmpty) {
                      return [
                        const ListTile(title: Text('Type to search users...')),
                      ];
                    }

                    if (localSearchResults.isEmpty) {
                      return [
                        const ListTile(title: Text('No User Found')),
                      ];
                    }

                    return localSearchResults
                        .map((user) => SearchTile(
                              userName: user.userName,
                              onPressed: () => _friendRequestController
                                  .sendRequest(user.uid),
                            ))
                        .toList();
                  },
                ),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.white.withAlpha((0.5 * 255).round()),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: CustomColors.black.withAlpha((0.4 * 255).round()),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[700],
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Received'),
                            SizedBox(
                              width: 10.w,
                            ),
                            Obx(() {
                              return CircleAvatar(
                                radius: 10.r,
                                backgroundColor: Colors.white,
                                child: Text(
                                  '${_friendRequestController.receivedRequests.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.black.withAlpha(
                                      (0.4 * 255).round(),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Sent'),
                            SizedBox(
                              width: 10.w,
                            ),
                            Obx(() {
                              return CircleAvatar(
                                radius: 10.r,
                                backgroundColor: Colors.white,
                                child: Text(
                                  '${_friendRequestController.sentRequests.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.black.withAlpha(
                                      (0.4 * 255).round(),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Obx(
                        () {
                          if (_friendRequestController
                              .receivedRequests.isEmpty) {
                            return const Center(
                              child: Text('No received requests.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: _friendRequestController
                                .receivedRequests.length,
                            itemBuilder: (context, index) {
                              final request = _friendRequestController
                                  .receivedRequests[index];
                              return FutureBuilder<UserModel?>(
                                future: _friendRequestController
                                    .getUserById(request.from),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const ListTile(
                                      title: Text('Loading...'),
                                    );
                                  }
                                  final user = snapshot.data!;
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.r,
                                        child: Text(user.firstName[0]),
                                      ),
                                      title: Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(
                                          color: CustomColors.black,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                              onPressed: () =>
                                                  _friendRequestController
                                                      .acceptRequest(request),
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Colors.green),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: CustomColors.white,
                                              )),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          TextButton(
                                              onPressed: () =>
                                                  _friendRequestController
                                                      .declineRequest(request),
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Colors.red),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: CustomColors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      Obx(
                        () {
                          if (_friendRequestController.sentRequests.isEmpty) {
                            return const Center(
                              child: Text('No sent requests.'),
                            );
                          }
                          return ListView.builder(
                            itemCount:
                                _friendRequestController.sentRequests.length,
                            itemBuilder: (context, index) {
                              final request =
                                  _friendRequestController.sentRequests[index];
                              return FutureBuilder<UserModel?>(
                                future: _friendRequestController
                                    .getUserById(request.to),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const ListTile(
                                      title: Text("Loading..."),
                                    );
                                  }
                                  final user = snapshot.data!;

                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.r,
                                        child: Text(user.firstName[0]),
                                      ),
                                      title: Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(
                                          color: CustomColors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: TextButton(
                                        onPressed: () =>
                                            _friendRequestController
                                                .cancelRequest(request),
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.red),
                                        ),
                                        child: Text(
                                          'Cancel Request',
                                          style: TextStyle(
                                            color: CustomColors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
