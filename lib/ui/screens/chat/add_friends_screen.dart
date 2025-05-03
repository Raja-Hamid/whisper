import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper/constants/colors.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  suggestionsBuilder: (context, controller) {
                    return [];
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
                        color: Colors.grey),
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
                            CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.white,
                              child: const Text(
                                '1',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
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
                            CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.white,
                              child: const Text(
                                '1',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      Center(child: Text('No Requests Received')),
                      Center(child: Text('No Requests Sent')),
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
