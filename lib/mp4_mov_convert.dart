import 'mp4_mov_convert_platform_interface.dart';

class Mp4MovConvert {
  Future<String?> getPlatformVersion() {
    return Mp4MovConvertPlatform.instance.getPlatformVersion();
  }

  /// Convert video from one format to another
  ///
  /// [inputPath]: The path to the input video file
  /// [outputPath]: The path where the converted video should be saved
  /// [outputFormat]: The desired output format (e.g., 'mp4', 'mov')
  ///
  /// Returns the path to the converted file on success, null on failure
  Future<String?> convertVideo({
    required String inputPath,
    required String outputPath,
    required String outputFormat,
  }) {
    return Mp4MovConvertPlatform.instance.convertVideo(
      inputPath: inputPath,
      outputPath: outputPath,
      outputFormat: outputFormat,
    );
  }
}
