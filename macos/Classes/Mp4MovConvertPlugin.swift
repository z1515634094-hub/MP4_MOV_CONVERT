import Cocoa
import FlutterMacOS
import AVFoundation

public class Mp4MovConvertPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mp4_mov_convert", binaryMessenger: registrar.messenger)
    let instance = Mp4MovConvertPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "convertVideo":
      guard let args = call.arguments as? [String: Any],
            let inputPath = args["inputPath"] as? String,
            let outputPath = args["outputPath"] as? String,
            let outputFormat = args["outputFormat"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS",
                           message: "Missing required arguments",
                           details: nil))
        return
      }
      convertVideo(inputPath: inputPath, outputPath: outputPath, outputFormat: outputFormat, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func convertVideo(inputPath: String, outputPath: String, outputFormat: String, result: @escaping FlutterResult) {
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Check if input file exists
    guard FileManager.default.fileExists(atPath: inputPath) else {
      result(FlutterError(code: "FILE_NOT_FOUND",
                         message: "Input file not found: \(inputPath)",
                         details: nil))
      return
    }
    
    let asset = AVURLAsset(url: inputURL)
    
    // Determine output file type
    let fileType: AVFileType
    switch outputFormat.lowercased() {
    case "mp4":
      fileType = .mp4
    case "mov":
      fileType = .mov
    default:
      result(FlutterError(code: "UNSUPPORTED_FORMAT",
                         message: "Unsupported output format: \(outputFormat)",
                         details: nil))
      return
    }
    
    // Check if export is possible
    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
      result(FlutterError(code: "EXPORT_SESSION_ERROR",
                         message: "Failed to create export session",
                         details: nil))
      return
    }
    
    // Remove output file if it exists
    if FileManager.default.fileExists(atPath: outputPath) {
      try? FileManager.default.removeItem(at: outputURL)
    }
    
    exportSession.outputURL = outputURL
    exportSession.outputFileType = fileType
    exportSession.shouldOptimizeForNetworkUse = true
    
    exportSession.exportAsynchronously {
      switch exportSession.status {
      case .completed:
        result(outputPath)
      case .failed:
        result(FlutterError(code: "EXPORT_FAILED",
                           message: "Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")",
                           details: nil))
      case .cancelled:
        result(FlutterError(code: "EXPORT_CANCELLED",
                           message: "Export was cancelled",
                           details: nil))
      default:
        result(FlutterError(code: "EXPORT_ERROR",
                           message: "Export failed with status: \(exportSession.status.rawValue)",
                           details: nil))
      }
    }
  }
}
