#pragma once
#include <emscripten/emscripten.h>
#include <emscripten/websocket.h>
#include "../sol/sol.hpp"

namespace sol_WebSocket
{
    void Init(sol::state& lua);
}
