import 'package:flutter/material.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';

import '../custom_icon_icons.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';

class NavBar extends StatefulWidget {
  static const String id = 'nav_bar';

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _pageOptions = [
    HomeScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            iconSize: deviceInfo.deviceType == DeviceType.Mobile
                ? deviceInfo.width * .05
                : deviceInfo.width * .05,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            selectedItemColor: Color(0xFF2A0651).withOpacity(.8),
            items: [
              BottomNavigationBarItem(
                title: Container(height: 0),
                icon: _currentIndex == 0
                    ? Icon(CustomIcon.home_filled)
                    : Icon(CustomIcon.home_outline),
              ),
              BottomNavigationBarItem(
                title: Container(height: 0),
                icon: _currentIndex == 1
                    ? Icon(CustomIcon.heart)
                    : Icon(CustomIcon.heart_empty),
              ),
            ],
          ),
          body: IndexedStack(
            children: _pageOptions,
            index: _currentIndex,
          ),
        );
      },
    );
  }
}
