#include "websocket.h"

EM_BOOL onopen(int eventType, const EmscriptenWebSocketOpenEvent *websocketEvent, void *userData) {
    CWebSocket* ws = static_cast<CWebSocket*>(userData);
    return ws->on_open(eventType, websocketEvent, userData);
}

EM_BOOL onerror(int eventType, const EmscriptenWebSocketErrorEvent *websocketEvent, void *userData) {
    CWebSocket* ws = static_cast<CWebSocket*>(userData);
    return ws->on_error(eventType, websocketEvent, userData);
}

EM_BOOL onclose(int eventType, const EmscriptenWebSocketCloseEvent *websocketEvent, void *userData) {
    CWebSocket* ws = static_cast<CWebSocket*>(userData);
    return ws->on_close(eventType, websocketEvent, userData);
}

EM_BOOL onmessage(int eventType, const EmscriptenWebSocketMessageEvent *websocketEvent, void *userData) {
    CWebSocket* ws = static_cast<CWebSocket*>(userData);
    return ws->on_message(eventType, websocketEvent, userData);
}

void CWebSocket::set_onopen_callback(WebSocket_open_callback f)
{
    _onopen = f;
}

void CWebSocket::set_onerror_callback(WebSocket_error_callback f)
{
    printf("set_onerror_callback \n");
    _onerror = f;
}

void CWebSocket::set_onclose_callback(WebSocket_close_callback f)
{
    _onclose = f;
}

void CWebSocket::set_onmessage_callback(WebSocket_message_callback f)
{
    _onmessage = f;
}

EMSCRIPTEN_RESULT CWebSocket::send_message(const std::string& msg)
{
    return emscripten_websocket_send_utf8_text(_ws, msg.c_str());
}

EM_BOOL CWebSocket::on_open(int eventType, const EmscriptenWebSocketOpenEvent *websocketEvent, void *userData)
{
    _onopen();
    return EM_TRUE;
}

EM_BOOL CWebSocket::on_error(int eventType, const EmscriptenWebSocketErrorEvent *websocketEvent, void *userData)
{
    _onerror();
    return EM_TRUE;
}

EM_BOOL CWebSocket::on_close(int eventType, const EmscriptenWebSocketCloseEvent *websocketEvent, void *userData)
{
    _onclose();
    return EM_TRUE;
}

EM_BOOL CWebSocket::on_message(int eventType, const EmscriptenWebSocketMessageEvent *websocketEvent, void *userData)
{
    printf("message: %s\n", websocketEvent->data);
    std::string messgage = (const char*)websocketEvent->data;
    _onmessage(messgage);
    return EM_TRUE;
}

CWebSocket* CWebSocket::_instance = nullptr;
CWebSocket* CWebSocket::getInstance()
{
    if (CWebSocket::_instance == nullptr)
    {
        size_t n = sizeof(CWebSocket);
        void* ptr = malloc(n);
        memset(ptr, 0x0, n);
        CWebSocket::_instance = (CWebSocket *)ptr;
        printf("CWebSocket createInstance ptr=%p\n", ptr);
    }
    return CWebSocket::_instance;
}

bool CWebSocket::connect(const std::string& url)
{
    printf("wss link to %s\n", url.c_str());
    close();
    EmscriptenWebSocketCreateAttributes ws_attrs = { url.c_str(), nullptr, EM_TRUE};
    _ws = emscripten_websocket_new(&ws_attrs);
    emscripten_websocket_set_onopen_callback(_ws, this, onopen);
    emscripten_websocket_set_onerror_callback(_ws, this, onerror);
    emscripten_websocket_set_onclose_callback(_ws, this, onclose);
    emscripten_websocket_set_onmessage_callback(_ws, this, onmessage);
    return true;
}

bool CWebSocket::close()
{
    printf("_ws = %d\n", _ws);
    if (_ws)
    {
        EMSCRIPTEN_RESULT result = emscripten_websocket_close(_ws, 1006, "close");
        if (result)
        {
            printf("Failed to emscripten_websocket_close(): %d\n", result);
            return false;
        }
        _ws = 0;
    }
    return true;
}