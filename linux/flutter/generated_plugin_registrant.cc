//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <http_io/http_io_plugin.h>
#include <printing/printing_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) http_io_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HttpIoPlugin");
  http_io_plugin_register_with_registrar(http_io_registrar);
  g_autoptr(FlPluginRegistrar) printing_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PrintingPlugin");
  printing_plugin_register_with_registrar(printing_registrar);
}
