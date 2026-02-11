import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mp4_mov_convert_method_channel.dart';

abstract class Mp4MovConvertPlatform extends PlatformInterface {
  /// Constructs a Mp4MovConvertPlatform.
  Mp4MovConvertPlatform() : super(token: _token);

  static final Object _token = Object();

  static Mp4MovConvertPlatform _instance = MethodChannelMp4MovConvert();

  /// The default instance of [Mp4MovConvertPlatform] to use.
  ///
  /// Defaults to [MethodChannelMp4MovConvert].
  static Mp4MovConvertPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Mp4MovConvertPlatform] when
  /// they register themselves.
  static set instance(Mp4MovConvertPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> convertVideo({
    required String inputPath,
    required String outputPath,
    required String outputFormat,
  }) {
    throw UnimplementedError('convertVideo() has not been implemented.');
  }
}
