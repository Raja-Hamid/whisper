import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whisper/ui/screens/chat/chats_list_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ChatsListScreen(),
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        destinations: [
          NavigationDestination(icon: SvgPicture.asset('assets/icons/chat.svg'), label: 'Chats'),
          NavigationDestination(icon: SvgPicture.asset('assets/icons/settings.svg'), label: 'Settings'),
        ],
      ),
    );
  }
}
