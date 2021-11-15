#pragma once
#include <emscripten/emscripten.h>
#include <emscripten/websocket.h>
#include "../sol/sol.hpp"
using WebSocket_open_callback = std::function<void(void)>;
using WebSocket_error_callback = std::function<void(void)>;
using WebSocket_close_callback = std::function<void(void)>;
using WebSocket_message_callback = std::function<void(std::string)>;
class CWebSocket{
private:
    CWebSocket();
    ~CWebSocket();
public:
    void set_onopen_callback(WebSocket_open_callback f);
    void set_onerror_callback(WebSocket_error_callback f);
    void set_onclose_callback(WebSocket_close_callback f);
    void set_onmessage_callback(WebSocket_message_callback f);
public:
    EMSCRIPTEN_RESULT send_message(const std::string& msg);
public:
    EM_BOOL on_open(int eventType, const EmscriptenWebSocketOpenEvent *websocketEvent, void *userData);
    EM_BOOL on_error(int eventType, const EmscriptenWebSocketErrorEvent *websocketEvent, void *userData);
    EM_BOOL on_close(int eventType, const EmscriptenWebSocketCloseEvent *websocketEvent, void *userData);
    EM_BOOL on_message(int eventType, const EmscriptenWebSocketMessageEvent *websocketEvent, void *userData);
public: 
    static CWebSocket* getInstance();
public:
    bool connect(const std::string& url);
    bool close();
private:
    EMSCRIPTEN_WEBSOCKET_T _ws = 0;
    WebSocket_open_callback _onopen;
    WebSocket_error_callback _onerror;
    WebSocket_close_callback _onclose;
    WebSocket_message_callback _onmessage;
    static CWebSocket* _instance;
};