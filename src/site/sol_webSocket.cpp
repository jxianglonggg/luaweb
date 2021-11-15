#include "sol_webSocket.h"
#include "websocket.h"

namespace sol_WebSocket
{
    bool connect(const std::string& url)
    {   
        CWebSocket* ws = CWebSocket::getInstance();
        return ws->connect(url);
    }
    bool close()
    {   
        CWebSocket* ws = CWebSocket::getInstance();
        return ws->close();
    }
    void set_onopen_callback(sol::function f)
    {
        WebSocket_open_callback cb = f;
        CWebSocket* ws = CWebSocket::getInstance();
        return ws->set_onopen_callback(cb);
    }
    void set_onmessage_callback(sol::function f)
    {
        WebSocket_message_callback cb = f;
        CWebSocket* ws = CWebSocket::getInstance();
        return ws->set_onmessage_callback(cb);
    }
    bool send_message(const std::string& msg)
    {
        CWebSocket* ws = CWebSocket::getInstance();
        return ws->send_message(msg);
    }

    void Init(sol::state& lua)
    {
        CWebSocket* ws = CWebSocket::getInstance();
        sol::table WebSocket = lua.create_named_table("WebSocket");
        WebSocket.set_function("connect", connect);
        WebSocket.set_function("close", close);
        WebSocket.set_function("set_onopen_callback", set_onopen_callback);
        WebSocket.set_function("set_onmessage_callback", set_onmessage_callback);
        WebSocket.set_function("send_message", send_message);
    }
}
