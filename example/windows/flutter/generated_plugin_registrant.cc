//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_js/flutter_js_plugin.h>
#include <smart_auth/smart_auth_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
    FlutterJsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("FlutterJsPlugin"));
    SmartAuthPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("SmartAuthPlugin"));
    UrlLauncherWindowsRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
