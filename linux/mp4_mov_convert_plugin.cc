#include "include/mp4_mov_convert/mp4_mov_convert_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "mp4_mov_convert_plugin_private.h"

#define MP4_MOV_CONVERT_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), mp4_mov_convert_plugin_get_type(), \
                              Mp4MovConvertPlugin))

struct _Mp4MovConvertPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(Mp4MovConvertPlugin, mp4_mov_convert_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void mp4_mov_convert_plugin_handle_method_call(
    Mp4MovConvertPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else if (strcmp(method, "convertVideo") == 0) {
    // Linux implementation would require FFmpeg
    response = FL_METHOD_RESPONSE(fl_method_error_response_new(
        "NOT_IMPLEMENTED",
        "Video conversion on Linux requires FFmpeg integration. "
        "This is a placeholder implementation.",
        nullptr));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void mp4_mov_convert_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(mp4_mov_convert_plugin_parent_class)->dispose(object);
}

static void mp4_mov_convert_plugin_class_init(Mp4MovConvertPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = mp4_mov_convert_plugin_dispose;
}

static void mp4_mov_convert_plugin_init(Mp4MovConvertPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  Mp4MovConvertPlugin* plugin = MP4_MOV_CONVERT_PLUGIN(user_data);
  mp4_mov_convert_plugin_handle_method_call(plugin, method_call);
}

void mp4_mov_convert_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  Mp4MovConvertPlugin* plugin = MP4_MOV_CONVERT_PLUGIN(
      g_object_new(mp4_mov_convert_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "mp4_mov_convert",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
