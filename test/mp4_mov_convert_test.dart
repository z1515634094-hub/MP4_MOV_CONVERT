import 'package:flutter_test/flutter_test.dart';
import 'package:mp4_mov_convert/mp4_mov_convert.dart';
import 'package:mp4_mov_convert/mp4_mov_convert_platform_interface.dart';
import 'package:mp4_mov_convert/mp4_mov_convert_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMp4MovConvertPlatform
    with MockPlatformInterfaceMixin
    implements Mp4MovConvertPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> convertVideo({
    required String inputPath,
    required String outputPath,
    required String outputFormat,
  }) =>
      Future.value('/path/to/converted/video.$outputFormat');
}

void main() {
  final Mp4MovConvertPlatform initialPlatform = Mp4MovConvertPlatform.instance;

  test('$MethodChannelMp4MovConvert is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMp4MovConvert>());
  });

  test('getPlatformVersion', () async {
    Mp4MovConvert mp4MovConvertPlugin = Mp4MovConvert();
    MockMp4MovConvertPlatform fakePlatform = MockMp4MovConvertPlatform();
    Mp4MovConvertPlatform.instance = fakePlatform;

    expect(await mp4MovConvertPlugin.getPlatformVersion(), '42');
  });

  test('convertVideo', () async {
    Mp4MovConvert mp4MovConvertPlugin = Mp4MovConvert();
    MockMp4MovConvertPlatform fakePlatform = MockMp4MovConvertPlatform();
    Mp4MovConvertPlatform.instance = fakePlatform;

    final result = await mp4MovConvertPlugin.convertVideo(
      inputPath: '/input/video.mp4',
      outputPath: '/output/video.mov',
      outputFormat: 'mov',
    );

    expect(result, '/path/to/converted/video.mov');
  });
}
