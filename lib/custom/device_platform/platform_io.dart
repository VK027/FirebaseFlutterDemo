import 'dart:io';
import 'device_platform.dart';
//Override default method, to provide .io access
DevicePlatformType get currentUniversalPlatform {
  if(Platform.isWindows) return DevicePlatformType.Windows;
  if(Platform.isFuchsia) return DevicePlatformType.Fuchsia;
  if(Platform.isMacOS) return DevicePlatformType.MacOS;
  if(Platform.isLinux) return DevicePlatformType.Linux;
  if(Platform.isIOS) return DevicePlatformType.IOS;
  if(Platform.isAndroid) return DevicePlatformType.Android;
  return DevicePlatformType.Web;
}

// DevicePlatformType get currentUniversalPlatform {
//   if(Platform.isWindows) return DevicePlatformType.Windows;
//   if(Platform.isFuchsia) return DevicePlatformType.Fuchsia;
//   if(Platform.isMacOS) return DevicePlatformType.MacOS;
//   if(Platform.isLinux) return DevicePlatformType.Linux;
//   if(Platform.isIOS) return DevicePlatformType.IOS;
//   if(Platform.isAndroid) return DevicePlatformType.Android;
//   return DevicePlatformType.Web;
// }