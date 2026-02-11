package com.ifreedomer.mp4mov_convert.mp4_mov_convert

import android.media.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.nio.ByteBuffer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** Mp4MovConvertPlugin */
class Mp4MovConvertPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mp4_mov_convert")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "convertVideo" -> {
                val inputPath = call.argument<String>("inputPath")
                val outputPath = call.argument<String>("outputPath")
                val outputFormat = call.argument<String>("outputFormat")

                if (inputPath == null || outputPath == null || outputFormat == null) {
                    result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    return
                }

                // Run conversion in background thread
                CoroutineScope(Dispatchers.Main).launch {
                    try {
                        val convertedPath = withContext(Dispatchers.IO) {
                            convertVideo(inputPath, outputPath, outputFormat)
                        }
                        result.success(convertedPath)
                    } catch (e: Exception) {
                        result.error("CONVERSION_ERROR", e.message, e.stackTraceToString())
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun convertVideo(inputPath: String, outputPath: String, outputFormat: String): String {
        val inputFile = File(inputPath)
        if (!inputFile.exists()) {
            throw Exception("Input file not found: $inputPath")
        }

        val outputFile = File(outputPath)
        if (outputFile.exists()) {
            outputFile.delete()
        }

        // Use MediaExtractor and MediaMuxer to remux the video
        val extractor = MediaExtractor()
        extractor.setDataSource(inputPath)

        val muxer = MediaMuxer(outputPath, when (outputFormat.lowercase()) {
            "mp4" -> MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4
            "mov" -> {
                // Android doesn't have native MOV support in MediaMuxer
                // We'll use MP4 as it's compatible
                MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4
            }
            else -> throw Exception("Unsupported output format: $outputFormat")
        })

        val trackCount = extractor.trackCount
        val trackIndexMap = mutableMapOf<Int, Int>()

        // Add all tracks to muxer
        for (i in 0 until trackCount) {
            val format = extractor.getTrackFormat(i)
            val muxerTrackIndex = muxer.addTrack(format)
            trackIndexMap[i] = muxerTrackIndex
        }

        muxer.start()

        // Copy all tracks
        for (i in 0 until trackCount) {
            extractor.selectTrack(i)
            
            val bufferInfo = MediaCodec.BufferInfo()
            val buffer = ByteBuffer.allocate(1024 * 1024) // 1MB buffer

            extractor.seekTo(0, MediaExtractor.SEEK_TO_PREVIOUS_SYNC)
            
            while (true) {
                val sampleSize = extractor.readSampleData(buffer, 0)
                if (sampleSize < 0) {
                    break
                }

                bufferInfo.offset = 0
                bufferInfo.size = sampleSize
                bufferInfo.presentationTimeUs = extractor.sampleTime
                bufferInfo.flags = extractor.sampleFlags

                val trackIndex = trackIndexMap[i] ?: continue
                muxer.writeSampleData(trackIndex, buffer, bufferInfo)
                
                extractor.advance()
            }
            
            extractor.unselectTrack(i)
        }

        muxer.stop()
        muxer.release()
        extractor.release()

        return outputPath
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
