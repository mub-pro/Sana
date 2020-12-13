import 'package:flutter/material.dart';

enum DeviceType { Mobile, Tablet }
DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  double width = mediaQueryData.size.width;

  if (width > 600) {
    return DeviceType.Tablet;
  }
  return DeviceType.Mobile;
}
