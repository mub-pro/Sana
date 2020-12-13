import 'package:flutter/material.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';

class NameOfSection extends StatelessWidget {
  final String name;
  NameOfSection({this.name});
  @override
  Widget build(BuildContext context) {
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return Stack(
          children: [
            Positioned(
              top: deviceInfo.deviceType == DeviceType.Mobile ? 20.0 : 50.0,
              right: deviceInfo.deviceType == DeviceType.Mobile ? 3.0 : 6.0,
              child: Container(
                  color: Color(0xFFFEEA6C),
                  width: MediaQuery.of(context).size.width,
                  height: 8.0),
            ),
            Text(
              name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize:
                      deviceInfo.deviceType == DeviceType.Mobile ? 25.0 : 50.0,
                  fontFamily: 'Dubai M',
                  color: Color(0xFF2A0651)),
            )
          ],
        );
      },
    );
  }
}
