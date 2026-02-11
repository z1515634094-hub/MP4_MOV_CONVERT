#ifndef FLUTTER_PLUGIN_MP4_MOV_CONVERT_PLUGIN_H_
#define FLUTTER_PLUGIN_MP4_MOV_CONVERT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace mp4_mov_convert {

class Mp4MovConvertPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  Mp4MovConvertPlugin();

  virtual ~Mp4MovConvertPlugin();

  // Disallow copy and assign.
  Mp4MovConvertPlugin(const Mp4MovConvertPlugin&) = delete;
  Mp4MovConvertPlugin& operator=(const Mp4MovConvertPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mp4_mov_convert

#endif  // FLUTTER_PLUGIN_MP4_MOV_CONVERT_PLUGIN_H_
