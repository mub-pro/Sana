import 'package:flutter/material.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';

import '../custom_icon_icons.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.06,
      left: MediaQuery.of(context).size.width * 0.04,
      child: WidgetInfo(
        builder: (context, deviceInfo) {
          return IconButton(
            iconSize: deviceInfo.deviceType == DeviceType.Mobile ? 50.0 : 100.0,
            icon: Icon(
              CustomIcon.left_open,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
