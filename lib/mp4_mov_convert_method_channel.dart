import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mp4_mov_convert_platform_interface.dart';

/// An implementation of [Mp4MovConvertPlatform] that uses method channels.
class MethodChannelMp4MovConvert extends Mp4MovConvertPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mp4_mov_convert');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> convertVideo({
    required String inputPath,
    required String outputPath,
    required String outputFormat,
  }) async {
    final result = await methodChannel.invokeMethod<String>('convertVideo', {
      'inputPath': inputPath,
      'outputPath': outputPath,
      'outputFormat': outputFormat,
    });
    return result;
  }
}
