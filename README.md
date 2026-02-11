# mp4_mov_convert

A Flutter plugin for converting video files between MP4 and MOV formats using native platform APIs.

## Features

- 🎥 Convert MP4 to MOV
- 🎬 Convert MOV to MP4
- 🚀 Native performance using platform-specific APIs
- 📱 Cross-platform support (iOS, macOS, Android)
- 🎯 Simple and easy-to-use API

## Platform Support

| Platform | Status | Implementation |
|----------|--------|----------------|
| iOS      | ✅ Full Support | AVFoundation (AVAssetExportSession) |
| macOS    | ✅ Full Support | AVFoundation (AVAssetExportSession) |
| Android  | ✅ Full Support | MediaExtractor & MediaMuxer |
| Windows  | ⚠️ Planned | Requires FFmpeg integration |
| Linux    | ⚠️ Planned | Requires FFmpeg integration |
| Web      | ❌ Not Supported | N/A |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  mp4_mov_convert: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:mp4_mov_convert/mp4_mov_convert.dart';

final converter = Mp4MovConvert();

// Convert MP4 to MOV
try {
  String? outputPath = await converter.convertVideo(
    inputPath: '/path/to/input.mp4',
    outputPath: '/path/to/output.mov',
    outputFormat: 'mov',
  );
  
  if (outputPath != null) {
    print('Conversion successful: $outputPath');
  }
} catch (e) {
  print('Conversion failed: $e');
}
```

### Complete Example with File Picker

```dart
import 'package:flutter/material.dart';
import 'package:mp4_mov_convert/mp4_mov_convert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<void> convertVideo() async {
  // Pick a video file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp4', 'mov'],
  );

  if (result != null && result.files.single.path != null) {
    String inputPath = result.files.single.path!;
    
    // Determine output format
    String inputExt = path.extension(inputPath).toLowerCase();
    String outputFormat = inputExt == '.mp4' ? 'mov' : 'mp4';
    
    // Get output directory
    Directory directory = await getApplicationDocumentsDirectory();
    String fileName = path.basenameWithoutExtension(inputPath);
    String outputPath = path.join(
      directory.path,
      '${fileName}_converted.$outputFormat',
    );
    
    // Convert
    final converter = Mp4MovConvert();
    try {
      String? result = await converter.convertVideo(
        inputPath: inputPath,
        outputPath: outputPath,
        outputFormat: outputFormat,
      );
      
      print('Success! Output: $result');
    } catch (e) {
      print('Error: $e');
    }
  }
}
```

## API Reference

### `Mp4MovConvert`

#### Methods

##### `convertVideo`

Converts a video file from one format to another.

```dart
Future<String?> convertVideo({
  required String inputPath,
  required String outputPath,
  required String outputFormat,
})
```

**Parameters:**
- `inputPath` (String, required): The full path to the input video file
- `outputPath` (String, required): The full path where the converted file should be saved
- `outputFormat` (String, required): The desired output format (`'mp4'` or `'mov'`)

**Returns:**
- `Future<String?>`: The path to the converted file on success, `null` on failure

**Throws:**
- `PlatformException`: When conversion fails or is not supported on the platform

##### `getPlatformVersion`

Gets the current platform version string.

```dart
Future<String?> getPlatformVersion()
```

**Returns:**
- `Future<String?>`: A string describing the platform and version

## Example App

The plugin includes a complete example app demonstrating:
- Video file selection using file picker
- Format detection and automatic output format suggestion
- Progress indication during conversion
- Error handling and user feedback
- Platform support status display

To run the example app:

```bash
cd example
flutter run
```

## Platform-Specific Details

### iOS / macOS

Uses `AVFoundation` framework with `AVAssetExportSession`:
- High-quality export preset
- Network optimization enabled
- Supports both MP4 and MOV containers
- Preserves video and audio quality

### Android

Uses `MediaExtractor` and `MediaMuxer`:
- Remuxes video and audio streams
- Efficient frame-by-frame copying
- Supports MP4 format natively
- MOV files are converted to MP4 (compatible format)
- Minimum SDK: 24 (Android 7.0)

### Windows / Linux

Currently returns a "not implemented" error. Full support will require FFmpeg integration in future versions.

## Error Handling

The plugin throws `PlatformException` with the following error codes:

| Error Code | Description |
|------------|-------------|
| `INVALID_ARGUMENTS` | Missing or invalid method arguments |
| `FILE_NOT_FOUND` | Input file does not exist |
| `UNSUPPORTED_FORMAT` | Requested output format is not supported |
| `EXPORT_SESSION_ERROR` | Failed to create export session (iOS/macOS) |
| `EXPORT_FAILED` | Video export/conversion failed |
| `EXPORT_CANCELLED` | Export was cancelled by user or system |
| `CONVERSION_ERROR` | General conversion error (Android) |
| `NOT_IMPLEMENTED` | Feature not available on this platform |

## Requirements

### iOS
- iOS 12.0 or higher
- Xcode 14.0 or higher

### macOS
- macOS 10.14 or higher
- Xcode 14.0 or higher

### Android
- Android API Level 24 (Android 7.0) or higher
- Kotlin 2.1.0 or higher

## Future Enhancements

- [ ] Add Windows support using FFmpeg
- [ ] Add Linux support using FFmpeg
- [ ] Support for additional video formats (AVI, MKV, etc.)
- [ ] Progress callbacks during conversion
- [ ] Video quality/bitrate options
- [ ] Batch conversion support
- [ ] Video trimming and editing features

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Created by ifreedomer

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.
