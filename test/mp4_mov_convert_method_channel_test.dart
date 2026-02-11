import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp4_mov_convert/mp4_mov_convert_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMp4MovConvert platform = MethodChannelMp4MovConvert();
  const MethodChannel channel = MethodChannel('mp4_mov_convert');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
