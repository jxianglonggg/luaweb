#include "site.h"

#include "../imgui/imgui.h"
#include "../sol/sol.hpp"
#include "../editor/TextEditor.h"
#include "background.h"
#include "sol_imGui.h"
#include "sol_webSocket.h"

namespace Site {

  static sol::state Lua;
  static TextEditor Editor;
  static std::string output;

  void Init() {
    Lua.open_libraries();
    sol_ImGui::Init(Lua);
    sol_WebSocket::Init(Lua);

    // overwrite print to have in window output
    Lua.set_function( "print", []( sol::variadic_args va ) {
      auto tostring = Lua.get<sol::function>("tostring");
      output = "";
      for( auto var : va ) {
          std::string s = tostring(var);
          output += " ";
          output += s;
      }
      printf("%s\n", output.c_str());
    } );
  }
  void Script() {
    Lua.script_file("/assert/main.lua"); 
  }

  void Tick() {
    Background background;

    Script();

    ImGui::SetNextWindowPos( ImVec2( 20, 20 ), ImGuiCond_Once );
    ImGui::SetNextWindowSize( ImVec2( 600, 600 ), ImGuiCond_Once );
  }

}
