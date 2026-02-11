import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mp4_mov_convert/mp4_mov_convert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _selectedFilePath = '';
  String _outputFormat = 'mp4';
  String _statusMessage = '';
  bool _isConverting = false;
  double _progress = 0.0;

  final _mp4MovConvertPlugin = Mp4MovConvert();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _mp4MovConvertPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov'],
      );

      if (result != null && result.files.single.path != null) {
        String selectedPath = result.files.single.path!;
        
        // Print selected file info
        print('\n📂 File selected:');
        print('Path: $selectedPath');
        print('Name: ${path.basename(selectedPath)}');
        print('Extension: ${path.extension(selectedPath)}');
        
        setState(() {
          _selectedFilePath = selectedPath;
          _statusMessage = 'Selected: ${path.basename(_selectedFilePath)}';

          // Auto-detect output format based on input
          String extension = path.extension(_selectedFilePath).toLowerCase();
          if (extension == '.mp4') {
            _outputFormat = 'mov';
            print('Auto-detected output format: MOV\n');
          } else if (extension == '.mov') {
            _outputFormat = 'mp4';
            print('Auto-detected output format: MP4\n');
          }
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error picking file: $e';
      });
    }
  }

  Future<void> _convertVideo() async {
    if (_selectedFilePath.isEmpty) {
      setState(() {
        _statusMessage = 'Please select a video file first';
      });
      return;
    }

    setState(() {
      _isConverting = true;
      _progress = 0.0;
      _statusMessage = 'Starting conversion...';
    });

    try {
      // Get output directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS || Platform.isMacOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getTemporaryDirectory();
      }

      // Create output path
      String fileName = path.basenameWithoutExtension(_selectedFilePath);
      String outputPath = path.join(
        directory!.path,
        '${fileName}_converted.$_outputFormat',
      );

      setState(() {
        _statusMessage = 'Converting to $_outputFormat...';
        _progress = 0.5;
      });

      // Print conversion details
      print('\n🎬 Starting video conversion...');
      print('📥 Input path:  $_selectedFilePath');
      print('📤 Output path: $outputPath');
      print('🎯 Format:      $_outputFormat');
      print('⏳ Converting...\n');

      // Perform conversion
      String? result = await _mp4MovConvertPlugin.convertVideo(
        inputPath: _selectedFilePath,
        outputPath: outputPath,
        outputFormat: _outputFormat,
      );

      setState(() {
        _progress = 1.0;
        _isConverting = false;
        if (result != null) {
          // Print full output path to console
          print('✅ Conversion successful!');
          print('📁 Output file path: $result');
          print('📄 File name: ${path.basename(result)}');
          print('📂 Directory: ${path.dirname(result)}');
          
          _statusMessage = 'Success! Saved to:\n$result';
        } else {
          _statusMessage = 'Conversion failed: No output file';
        }
      });
    } on PlatformException catch (e) {
      print('❌ Conversion failed!');
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
      
      setState(() {
        _isConverting = false;
        _progress = 0.0;
        _statusMessage = 'Error: ${e.code}\n${e.message}';
      });
    } catch (e) {
      print('❌ Unexpected error occurred!');
      print('Error: $e');
      
      setState(() {
        _isConverting = false;
        _progress = 0.0;
        _statusMessage = 'Unexpected error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MP4 MOV Convert Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Platform Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Running on:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        _platformVersion,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // File Selection
              Text(
                'Step 1: Select Video File',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _isConverting ? null : _pickVideoFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Pick Video File (.mp4 or .mov)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_selectedFilePath.isNotEmpty) ...[
                const SizedBox(height: 8),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            path.basename(_selectedFilePath),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Output Format Selection
              Text(
                'Step 2: Select Output Format',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'mp4',
                    label: Text('MP4'),
                    icon: Icon(Icons.video_file),
                  ),
                  ButtonSegment(
                    value: 'mov',
                    label: Text('MOV'),
                    icon: Icon(Icons.movie),
                  ),
                ],
                selected: {_outputFormat},
                onSelectionChanged: _isConverting
                    ? null
                    : (Set<String> selected) {
                        setState(() {
                          _outputFormat = selected.first;
                        });
                      },
              ),
              const SizedBox(height: 24),

              // Convert Button
              Text(
                'Step 3: Convert',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: (_isConverting || _selectedFilePath.isEmpty)
                    ? null
                    : _convertVideo,
                icon: _isConverting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.transform),
                label: Text(_isConverting ? 'Converting...' : 'Convert Video'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              // Progress Indicator
              if (_isConverting) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(value: _progress),
              ],

              // Status Message
              if (_statusMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: _statusMessage.contains('Error')
                      ? Colors.red.shade50
                      : _statusMessage.contains('Success')
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _statusMessage.contains('Error')
                              ? Icons.error_outline
                              : _statusMessage.contains('Success')
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          color: _statusMessage.contains('Error')
                              ? Colors.red
                              : _statusMessage.contains('Success')
                              ? Colors.green
                              : Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Info Card
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Platform Support',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '✅ iOS: Full support using AVFoundation\n'
                        '✅ macOS: Full support using AVFoundation\n'
                        '✅ Android: Full support using MediaMuxer\n'
                        '⚠️ Windows: Requires FFmpeg (not implemented)\n'
                        '⚠️ Linux: Requires FFmpeg (not implemented)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
