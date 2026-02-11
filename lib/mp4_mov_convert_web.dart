// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'mp4_mov_convert_platform_interface.dart';

/// A web implementation of the Mp4MovConvertPlatform of the Mp4MovConvert plugin.
class Mp4MovConvertWeb extends Mp4MovConvertPlatform {
  /// Constructs a Mp4MovConvertWeb
  Mp4MovConvertWeb();

  static void registerWith(Registrar registrar) {
    Mp4MovConvertPlatform.instance = Mp4MovConvertWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
