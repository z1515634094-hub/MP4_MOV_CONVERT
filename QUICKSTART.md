# Quick Start Guide

Get started with `mp4_mov_convert` in just a few minutes!

## 1. Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mp4_mov_convert: ^1.0.0
```

Run:
```bash
flutter pub get
```

## 2. Platform Configuration

### iOS (Info.plist)

Add to `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to select videos for conversion</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save converted videos</string>
```

### macOS (Entitlements)

Add to `macos/Runner/DebugProfile.entitlements` and `Release.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

### Android (AndroidManifest.xml)

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
```

## 3. Basic Usage

### Simple Conversion

```dart
import 'package:mp4_mov_convert/mp4_mov_convert.dart';

final converter = Mp4MovConvert();

// Convert MP4 to MOV
String? result = await converter.convertVideo(
  inputPath: '/path/to/video.mp4',
  outputPath: '/path/to/output.mov',
  outputFormat: 'mov',
);

if (result != null) {
  print('Conversion successful: $result');
}
```

### With File Picker

```dart
import 'package:mp4_mov_convert/mp4_mov_convert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<void> convertVideo() async {
  // 1. Pick a file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp4', 'mov'],
  );
  
  if (result == null) return;
  
  String inputPath = result.files.single.path!;
  
  // 2. Prepare output path
  Directory dir = await getApplicationDocumentsDirectory();
  String fileName = path.basenameWithoutExtension(inputPath);
  String outputPath = path.join(dir.path, '${fileName}_converted.mp4');
  
  // 3. Convert
  final converter = Mp4MovConvert();
  try {
    String? output = await converter.convertVideo(
      inputPath: inputPath,
      outputPath: outputPath,
      outputFormat: 'mp4',
    );
    print('Success: $output');
  } catch (e) {
    print('Error: $e');
  }
}
```

### With Error Handling

```dart
import 'package:flutter/services.dart';

Future<void> convertWithErrorHandling() async {
  try {
    String? result = await converter.convertVideo(
      inputPath: inputPath,
      outputPath: outputPath,
      outputFormat: outputFormat,
    );
    
    if (result != null) {
      // Success!
      showSuccessMessage('Converted: $result');
    }
  } on PlatformException catch (e) {
    // Handle specific errors
    switch (e.code) {
      case 'FILE_NOT_FOUND':
        showError('Input file not found');
        break;
      case 'UNSUPPORTED_FORMAT':
        showError('Format not supported');
        break;
      case 'EXPORT_FAILED':
        showError('Conversion failed: ${e.message}');
        break;
      default:
        showError('Error: ${e.message}');
    }
  }
}
```

## 4. Common Patterns

### Auto-detect Output Format

```dart
String inputPath = '/path/to/video.mp4';
String inputExt = path.extension(inputPath).toLowerCase();
String outputFormat = inputExt == '.mp4' ? 'mov' : 'mp4';
```

### Generate Output Path

```dart
String generateOutputPath(String inputPath, String format) {
  Directory dir = await getApplicationDocumentsDirectory();
  String fileName = path.basenameWithoutExtension(inputPath);
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  return path.join(dir.path, '${fileName}_$timestamp.$format');
}
```

### Show Progress

```dart
setState(() {
  _isConverting = true;
  _statusMessage = 'Converting...';
});

try {
  String? result = await converter.convertVideo(...);
  setState(() {
    _isConverting = false;
    _statusMessage = 'Success!';
  });
} catch (e) {
  setState(() {
    _isConverting = false;
    _statusMessage = 'Failed: $e';
  });
}
```

## 5. Run the Example

See a complete working example:

```bash
cd example
flutter run
```

## Next Steps

- Read the [full README](README.md) for detailed documentation
- Check out the [example app](example/) for a complete implementation
- Review the [CHANGELOG](CHANGELOG.md) for version history

## Need Help?

If you encounter issues:

1. Check that your platform is supported (iOS, macOS, Android)
2. Verify permissions are properly configured
3. Ensure the input file exists and is a valid video
4. Check the error code and message for specific issues

For more help, see the troubleshooting section in the [main README](README.md).
