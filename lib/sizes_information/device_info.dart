import 'device_type.dart';

class DeviceInfo {
  final DeviceType deviceType;
  final double height;
  final double width;
  final double localHeight;
  final double localWidth;

  DeviceInfo({
    this.deviceType,
    this.width,
    this.height,
    this.localHeight,
    this.localWidth,
  });
}
