#include "include/mp4_mov_convert/mp4_mov_convert_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "mp4_mov_convert_plugin.h"

void Mp4MovConvertPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  mp4_mov_convert::Mp4MovConvertPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
