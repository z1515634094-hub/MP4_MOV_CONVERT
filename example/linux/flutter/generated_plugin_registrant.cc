//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <mp4_mov_convert/mp4_mov_convert_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) mp4_mov_convert_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Mp4MovConvertPlugin");
  mp4_mov_convert_plugin_register_with_registrar(mp4_mov_convert_registrar);
}
