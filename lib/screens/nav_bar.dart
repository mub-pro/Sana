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

  void onItemTapped(int index) {
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
        print(deviceInfo.deviceType);
        return Scaffold(
          bottomNavigationBar: Container(
            height: deviceInfo.deviceType == DeviceType.Mobile
                ? deviceInfo.height * 0.1
                : 80.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 20,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: BottomNavigationBar(
              iconSize:
                  deviceInfo.deviceType == DeviceType.Mobile ? 25.0 : 40.0,
              currentIndex: _currentIndex,
              onTap: onItemTapped,
              selectedItemColor: Color(0xFF2A0651),
              items: [
                BottomNavigationBarItem(
                  title: Container(height: 0.0),
                  icon: _currentIndex == 0
                      ? Icon(CustomIcon.home_filled)
                      : Icon(CustomIcon.home_outline),
                ),
                BottomNavigationBarItem(
                  title: Container(height: 0.0),
                  icon: _currentIndex == 1
                      ? Icon(CustomIcon.heart)
                      : Icon(CustomIcon.heart_empty),
                ),
              ],
            ),
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
