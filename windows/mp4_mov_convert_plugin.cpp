#include "mp4_mov_convert_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace mp4_mov_convert {

// static
void Mp4MovConvertPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "mp4_mov_convert",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<Mp4MovConvertPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

Mp4MovConvertPlugin::Mp4MovConvertPlugin() {}

Mp4MovConvertPlugin::~Mp4MovConvertPlugin() {}

void Mp4MovConvertPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name().compare("convertVideo") == 0) {
    // Windows implementation would require FFmpeg or Media Foundation
    result->Error("NOT_IMPLEMENTED",
                 "Video conversion on Windows requires FFmpeg integration. "
                 "This is a placeholder implementation.",
                 flutter::EncodableValue());
  } else {
    result->NotImplemented();
  }
}

}  // namespace mp4_mov_convert
