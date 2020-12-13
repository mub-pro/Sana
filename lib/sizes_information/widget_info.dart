import 'package:flutter/material.dart';

import 'device_info.dart';
import 'device_type.dart';

class WidgetInfo extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;
  WidgetInfo({this.builder});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        var mediaQueryData = MediaQuery.of(context);
        var deviceInfo = DeviceInfo(
          deviceType: getDeviceType(mediaQueryData),
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          localHeight: constrains.maxHeight,
          localWidth: constrains.maxWidth,
        );
        return builder(context, deviceInfo);
      },
    );
  }
}
