local show_app_main_menu_bar = false;
local show_app_documents = false;
local show_app_console = false;
local show_app_log = false;
local show_app_layout = false;
local show_app_property_editor = false;
local show_app_long_text = false;
local show_app_auto_resize = false;
local show_app_constrained_resize = false;
local show_app_simple_overlay = false;
local show_app_window_titles = false;
local show_app_custom_rendering = false;

local function ShowExampleMenuFile()
    if( ImGui.MenuItem( "New" ) ) then
    end
    if( ImGui.MenuItem( "Open", "Ctrl+O" ) ) then
    end
    if( ImGui.BeginMenu( "Open Recent" ) ) then
        ImGui.MenuItem( "fish_hat.c" );
        ImGui.MenuItem( "fish_hat.inl" );
        ImGui.MenuItem( "fish_hat.h" );
        if( ImGui.BeginMenu( "More.." ) ) then
            ImGui.MenuItem( "Hello" );
            ImGui.MenuItem( "Sailor" );
            if( ImGui.BeginMenu( "Recurse.." ) ) then
                ShowExampleMenuFile();
                ImGui.EndMenu();
            end
            ImGui.EndMenu();
        end
        ImGui.EndMenu();
    end
    if( ImGui.MenuItem( "Save", "Ctrl+S" ) ) then end
    if( ImGui.MenuItem( "Save As.." ) ) then end
    ImGui.Separator();
    if( ImGui.BeginMenu( "Options" ) ) then
        local f = 0.5;
        local n = 0;
        f = ImGui.SliderFloat( "Value", f, 0.0, 1.0 );
        f = ImGui.InputFloat( "Input", f, 0.1 );
        n = ImGui.Combo( "Combo", n, "Yes\0No\0Maybe\0\0" );
        ImGui.EndMenu();
    end
end

function ShowExampleAppMainMenuBar()
    if ImGui.BeginMainMenuBar() then
        if ImGui.BeginMenu( "File" )  then
            ShowExampleMenuFile();
            ImGui.EndMenu();
        end
        if ImGui.BeginMenu( "Edit" ) then
            if ImGui.MenuItem( "Undo", "CTRL+Z" ) then
            end
            if ImGui.MenuItem( "Redo", "CTRL+Y", false, false ) then
            end
            ImGui.Separator();
            if ImGui.MenuItem( "Cut", "CTRL+X" ) then
            end
            if ImGui.MenuItem( "Copy", "CTRL+C" ) then
            end
            if ImGui.MenuItem( "Paste", "CTRL+V" ) then
            end
            ImGui.EndMenu();
        end  
        ImGui.EndMainMenuBar();
    end
end

function show_window()
    ImGui.Begin("Hello World Windows", true, ImGuiWindowFlags.MenuBar)
    if ImGui.BeginMenuBar() then
        if ImGui.BeginMenu( "Menu" ) then
            ShowExampleMenuFile()
            ImGui.EndMenu();
        end
        if ImGui.BeginMenu( "Examples" ) then
            show_app_main_menu_bar = ImGui.MenuItem( "Main menu bar", nil, show_app_main_menu_bar );
            ImGui.MenuItem( "Console", nil, show_app_console );
            ImGui.MenuItem( "Log", nil, show_app_log );
            ImGui.MenuItem( "Simple layout", nil, show_app_layout );
            ImGui.MenuItem( "Property editor", nil, show_app_property_editor );
            ImGui.MenuItem( "Long text display", nil, show_app_long_text );
            ImGui.MenuItem( "Auto-resizing window", nil, show_app_auto_resize );
            ImGui.MenuItem( "Constrained-resizing window", nil, show_app_constrained_resize );
            ImGui.MenuItem( "Simple overlay", nil, show_app_simple_overlay );
            ImGui.MenuItem( "Manipulating window titles", nil, show_app_window_titles );
            ImGui.MenuItem( "Custom rendering", nil, show_app_custom_rendering );
            ImGui.MenuItem( "Documents", nil, show_app_documents );
            ImGui.EndMenu();
        end
    
        if ImGui.BeginMenu( "Tools" ) then
            ImGui.MenuItem( "Metrics", nil, show_app_metrics );
            ImGui.MenuItem( "Style Editor", nil, show_app_style_editor );
            ImGui.MenuItem( "About Dear ImGui", nil, show_app_about );
            ImGui.EndMenu();
        end
        ImGui.EndMenuBar();
    end
    if ImGui.CollapsingHeader( "Help" ) then
        ImGui.Text( "ABOUT THIS DEMO:" )
        ImGui.BulletText( "Sections below are demonstrating many aspects of the library." );
        ImGui.BulletText( "The \"Examples\" menu above leads to more demo contents." );
        ImGui.BulletText( "The \"Tools\" menu above gives access to: About Box, Style Editor,\nand Metrics (general purpose Dear ImGui debugging tool)." )
        ImGui.Separator()
    
        ImGui.Text( "PROGRAMMER GUIDE:" );
        ImGui.BulletText( "See the ShowDemoWindow() code in imgui_demo.cpp. <- you are here!" );
        ImGui.BulletText( "See comments in imgui.cpp." );
        ImGui.BulletText( "See example applications in the examples/ folder." );
        ImGui.BulletText( "Read the FAQ at http://www.dearimgui.org/faq/" );
        ImGui.BulletText( "Set 'io.ConfigFlags |= NavEnableKeyboard' for keyboard controls." );
        ImGui.BulletText( "Set 'io.ConfigFlags |= NavEnableGamepad' for gamepad controls." );
        ImGui.Separator();
    
        ImGui.Text( "USER GUIDE:" )
        --ImGui::ShowUserGuide();
    end
    if show_app_main_menu_bar then
        ShowExampleAppMainMenuBar()
    end
    ImGui.End()
end

G_initd = G_initd or false
function link_server()
    print("start link server ...")
    local result = WebSocket.connect("ws://192.168.0.170:9948")
    print("result =", 123)
    WebSocket.set_onopen_callback(function()
        print("web socket open")
        WebSocket.send_message("ping")
    end)
    WebSocket.set_onmessage_callback(function(msg)
        print("WebSocket on message")
        print(msg)
        if msg == "ping" then 
            WebSocket.send_message("pong")
        elseif msg == "pong" then
            WebSocket.send_message("ping")
        end
    end)
end

show_window()
if not G_initd then
    link_server()
    G_initd = true
end
