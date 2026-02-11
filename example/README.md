# MP4 MOV Convert Example App

This is an example application demonstrating how to use the `mp4_mov_convert` plugin.

## Features

- 📁 Select video files (MP4 or MOV) using file picker
- 🔄 Convert between MP4 and MOV formats
- 📊 Real-time conversion progress indication
- ✅ Success/error feedback with detailed messages
- 🎨 Modern Material Design 3 UI
- 📱 Platform support indicator

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- For iOS: Xcode 14.0 or higher, iOS 12.0+
- For macOS: Xcode 14.0 or higher, macOS 10.14+
- For Android: Android Studio, API Level 24+

### Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run on your preferred platform:
   ```bash
   # iOS
   flutter run -d ios
   
   # macOS
   flutter run -d macos
   
   # Android
   flutter run -d android
   ```

## How to Use the App

1. **Step 1: Select Video File**
   - Tap "Pick Video File" button
   - Select a .mp4 or .mov file from your device
   - The app will auto-detect the file format

2. **Step 2: Select Output Format**
   - Choose MP4 or MOV as the output format
   - The app automatically suggests the opposite format

3. **Step 3: Convert**
   - Tap "Convert Video" button
   - Wait for the conversion to complete
   - The converted file will be saved to your device

## Platform-Specific Notes

### iOS
- Requires photo library permissions for file access
- Converted files are saved to the app's documents directory
- Uses AVFoundation for high-quality conversion

### macOS
- Requires file access permissions
- Converted files are saved to the app's documents directory
- Uses AVFoundation for high-quality conversion

### Android
- Requires storage permissions (automatically handled for Android 13+)
- Converted files are saved to external storage
- Uses MediaExtractor and MediaMuxer for conversion

### Windows & Linux
- Currently displays "not implemented" error
- Full support coming in future versions with FFmpeg integration

## Code Example

Here's the core conversion logic used in the app:

```dart
import 'package:mp4_mov_convert/mp4_mov_convert.dart';

final converter = Mp4MovConvert();

try {
  String? result = await converter.convertVideo(
    inputPath: selectedFilePath,
    outputPath: outputPath,
    outputFormat: 'mp4', // or 'mov'
  );
  
  if (result != null) {
    print('Success! Saved to: $result');
  }
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
}
```

## Dependencies

This example uses the following packages:

- `mp4_mov_convert`: The video conversion plugin
- `file_picker`: For selecting video files
- `path_provider`: For getting storage directories
- `path`: For path manipulation

## Troubleshooting

### iOS/macOS: "Permission Denied"
Make sure the Info.plist includes the required privacy keys:
- `NSPhotoLibraryUsageDescription`
- `NSPhotoLibraryAddUsageDescription`

### Android: "File not found"
Ensure the app has proper storage permissions and the file path is correct.

### Conversion fails
- Check that the input file is a valid video file
- Ensure there's enough storage space
- Verify the file format is supported (MP4 or MOV)

## Learn More

For more information about the plugin, see the [main README](../README.md).
