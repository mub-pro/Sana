import 'package:flutter/material.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';

class NameOfRow extends StatelessWidget {
  final String name;
  NameOfRow({this.name});
  @override
  Widget build(BuildContext context) {
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return Stack(
          children: [
            Positioned(
              top: deviceInfo.localHeight * .6,
              right: deviceInfo.deviceType == DeviceType.Mobile ? 3.0 : 6.0,
              child: Container(
                  color: Color(0xFFFEEA6C),
                  width: MediaQuery.of(context).size.width,
                  height: deviceInfo.localHeight * 0.1),
            ),
            Text(
              name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: deviceInfo.deviceType == DeviceType.Mobile
                      ? deviceInfo.localHeight * 0.6
                      : deviceInfo.localHeight * 0.7,
                  fontFamily: 'Dubai R',
                  color: Color(0xFF2A0651)),
            )
          ],
        );
      },
    );
  }
}
