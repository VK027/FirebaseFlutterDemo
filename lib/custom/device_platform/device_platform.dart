import 'device_platform_locator.dart' if(dart.library.io) 'src/platform_io.dart';
//Default to web, the platform_io class will override this if it gets imported.
//DevicePlatformType get currentUniversalPlatform => DevicePlatformType.Web;

abstract class DevicePlatform {

  static DevicePlatformType get value => currentUniversalPlatform;

  static bool get isWeb => currentUniversalPlatform == DevicePlatformType.Web;
  static bool get isMacOS => currentUniversalPlatform == DevicePlatformType.MacOS;
  static bool get isWindows => currentUniversalPlatform == DevicePlatformType.Windows;
  static bool get isLinux => currentUniversalPlatform == DevicePlatformType.Linux;
  static bool get isAndroid => currentUniversalPlatform == DevicePlatformType.Android;
  static bool get isIOS => currentUniversalPlatform == DevicePlatformType.IOS;
  static bool get isFuchsia => currentUniversalPlatform == DevicePlatformType.Fuchsia;

  static bool get isDesktop => isLinux || isMacOS || isWindows;
  static bool get isDesktopOrWeb => isDesktop;

  static String get operatingSystem {
    switch (value) {
      case DevicePlatformType.Web:
        return "web";
      case DevicePlatformType.MacOS:
        return "macos";
      case DevicePlatformType.Windows:
        return "windows";
      case DevicePlatformType.Linux:
        return "linux";
      case DevicePlatformType.Android:
        return "android";
      case DevicePlatformType.IOS:
        return "ios";
      case DevicePlatformType.Fuchsia:
        return "fuchsia";
    }
  }
}

enum DevicePlatformType { Web, Windows, Linux, MacOS, Android, Fuchsia, IOS }


