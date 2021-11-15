-- Imgui and lua on the web
set_plat("wasm")
-- with emscripten
set_languages("c++17")

add_rules("mode.release", "mode.debug")
-- runtime
add_cxflags("-g4 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s DISABLE_EXCEPTION_CATCHING=0 -s NO_EXIT_RUNTIME=0 -s ASSERTIONS=1")
add_ldflags("-g4 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s DISABLE_EXCEPTION_CATCHING=0 -s NO_EXIT_RUNTIME=0 -s ASSERTIONS=1 -fdebug-compilation-dir=.")

target("editor")
	set_kind("static")
	add_files("./src/editor/*.cpp")

target("lua")
	set_kind("static")
	add_files("./src/lua/*.c")
	add_defines("LUA_USE_LINUX")

target("imgui")
	set_kind("static")
	add_files("./src/imgui/*.cpp")

	add_defines("DIMGUI_DISABLE_FILE_FUNCTIONS")
	add_cxflags("-s USE_SDL=2")
	add_ldflags("-s USE_SDL=2")

target("site")
	set_kind("static")
	add_files("./src/site/*.cpp")

target("toy")
	set_kind("binary")
	add_files("./src/*.cpp")

	-- lua fun
	add_deps("lua")

	-- imgui for a gui and lazy mans renderer
	add_deps("imgui")

	-- editor widget
	add_deps("editor")

	-- site logic
	add_deps("site")

	--html file to embed in
	add_ldflags("--shell-file ./src/shell_minimal.html")
	add_ldflags("--embed-file ./assert")
	

	-- SDL2
	add_cxflags("-s USE_SDL=2")
	add_ldflags("-s USE_SDL=2")

	--load main.lua
	add_cxflags("-s FORCE_FILESYSTEM=1")
	add_ldflags("-s FORCE_FILESYSTEM=1")

	--no popen
	add_cxflags("-s ERROR_ON_UNDEFINED_SYMBOLS=0")
	add_ldflags("-s ERROR_ON_UNDEFINED_SYMBOLS=0")

	add_ldflags("-lwebsocket.js")

	 if is_mode("debug") then
        add_defines("EMCC_DEBUG=1")
    end

	on_run(function(target)
		os.execv("emrun --port 8080 ", {target:targetfile()})
	end)

--[[O-O]]--
