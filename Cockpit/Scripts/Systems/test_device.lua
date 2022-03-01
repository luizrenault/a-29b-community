-- dofile(LockOn_Options.common_script_path.."mission_prepare.lua")

-- dofile ("scripts/Database/db_scan.lua")

dofile(LockOn_Options.script_path.."dump.lua")
--package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
--local avwr = require('avSimplestRadio')   -- loads the DLL



dump("_G",_G)
dump("_G",getmetatable(_G))


--dump("list_indication",getmetatable(list_indication()))


dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("test: load")

local dev = GetSelf()



-- dump1("avwr", avwr)

-- log.alert("----------------------------------")
-- dump1("dev",dev)
-- dump1("_dev", getmetatable(dev))

local update_time_step = 0.02 --update will be called 50 times per second
if make_default_activity ~= nil then make_default_activity(update_time_step) end


local sensor_data = get_base_data()

local elapsed = 5

function update()
    if elapsed > 0 then
        elapsed = elapsed - update_time_step
    elseif elapsed > -1 then
        -- log.alert("----------------------------------")
        -- dump1("dev",dev)
        -- dump1("_dev", getmetatable(dev))
        -- print_message_to_user("Dumped!")
        -- dump1("Params\n", list_cockpit_params())
        elapsed = -1
    end

end


function post_initialize()
    startup_print("test: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    -- print_message_to_user("Dumped!")
    -- dump1("Params\n", list_cockpit_params())
    -- dump1("get_mission_route", get_mission_route())
    startup_print("test: postinit end")
end

PlaneModeNAV                    = 105
PlaneModeBVR                    = 106
PlaneModeVS                     = 107
PlaneModeBore                   = 108
PlaneModeGround                 = 111

local iCommandPlaneWingtipSmokeOnOff = 78
local iCommandPlaneJettisonWeapons = 82
local iCommandPlaneFire = 84
local iCommandPlaneFireOff = 85
local iCommandPlaneChangeWeapon = 101
local iCommandActiveJamming = 136
local iCommandPlaneJettisonFuelTanks = 178
local iCommandPlanePickleOn = 350
local iCommandPlanePickleOff = 351
local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358
local iCommandPlaneChangeTarget = 102

-- dev:listen_command(PlaneModeNAV)
-- dev:listen_command(PlaneModeBVR)
-- dev:listen_command(PlaneModeVS)
-- dev:listen_command(PlaneModeBore)
-- dev:listen_command(PlaneModeGround)

-- dev:listen_command(iCommandPlaneChangeTarget)
-- dev:listen_command(iCommandPlaneWingtipSmokeOnOff)
-- dev:listen_command(iCommandPlaneJettisonWeapons)
-- dev:listen_command(iCommandPlaneFire)
-- dev:listen_command(iCommandPlaneFireOff)
-- dev:listen_command(iCommandPlaneChangeWeapon)
-- dev:listen_command(iCommandActiveJamming)
-- dev:listen_command(iCommandPlaneJettisonFuelTanks)
-- dev:listen_command(iCommandPlanePickleOn)
-- dev:listen_command(iCommandPlanePickleOff)
-- dev:listen_command(iCommandPlaneDropFlareOnce)
-- dev:listen_command(iCommandPlaneDropChaffOnce)
local iPlaneAirBrakeOn = 147
local iPlaneAirBrakeOff = 148

for i=1, 50000 do
    if i== 1032 or i == 1033 or i == 1034 then
    --elseif i==74 or i==75 then
    elseif i== 2001 or i == 1033 or i == 2002 or i == 350 then
    elseif i== 93 or i == 94 or i == 95 or i == 96 or i == 98 or i == 99 or i == 215 then --trim
    elseif i ~= 2142 and i~= 2143 and (i < 193 or i> 204)  then 
        dev:listen_command(i)
    end
end
function SetCommand(command,value)
    print_message_to_user("test: command "..tostring(command).." = "..tostring(value))

    if command == 74 then 
        local radio = GetDevice(devices.VUHF1_RADIO)
        dispatch_action(devices.VUHF1_RADIO, 179, 1)
    elseif command == 179 then 
        -- print_message_to_user("Setup: " .. avSimplestRadio.avSimplestRadioSetup())
        -- local wpn = GetDevice(devices.WEAPON_SYSTEM)
        -- local WS_DLZ_MAX = get_param_handle("WS_DLZ_MAX")
        -- local WS_DLZ_MIN = get_param_handle("WS_DLZ_MIN")
        -- WS_DLZ_MAX:set(1500)
        -- WS_DLZ_MIN:set(1100)
        -- print_message_to_user("Ralt: " .. sensor_data.getRadarAltitude())
        --  print_message_to_user("WS_DLZ_MIN:" .. WS_DLZ_MIN:get().. "\t WS_DLZ_MAX:"..WS_DLZ_MAX:get())

        -- for i=1,5 do
        --     local text = dump("STO"..i, wpn:get_station_info(i-1))
        --     -- print_message_to_user(text)
        --     log.info(text)
        -- end
        -- print_message_to_user("Dumped!")
        -- local text = dump("Params\n", list_cockpit_params())
        -- text = strsplit("\n", text)
        -- for key, value in pairs(text) do
        --     log.info(value)
        -- end
        -- dispatch_action(nil,iPlaneAirBrakeOn)
    end
end

startup_print("test: load end")
need_to_be_closed = false -- close lua state after initialization





-- _G = {}
-- _G["SetGlobalCommand"] = function: 0000023397DDB7B0
-- _G["log"] = {}
-- _G["log"]["FULL"] = 263
-- _G["log"]["TIME_LOCAL"] = 129
-- _G["log"]["ALL"] = 255
-- _G["log"]["set_output"] = function: 0000023397DD7EE0
-- _G["log"]["LEVEL"] = 2
-- _G["log"]["DEBUG"] = 128
-- _G["log"]["IMMEDIATE"] = 1
-- _G["log"]["ASYNC"] = 0
-- _G["log"]["MODULE"] = 4
-- _G["log"]["ALERT"] = 2
-- _G["log"]["RELIABLE"] = 32768
-- _G["log"]["warning"] = function: 0000022BF25BBA30
-- _G["log"]["debug"] = function: 0000022BF25BBE30
-- _G["log"]["write"] = function: 0000023397DD7EB0
-- _G["log"]["printf"] = function: 0000023397DD7E50
-- _G["log"]["TIME_UTC"] = 1
-- _G["log"]["TIME"] = 1
-- _G["log"]["WARNING"] = 16
-- _G["log"]["INFO"] = 64
-- _G["log"]["error"] = function: 0000022BF25BBDF0
-- _G["log"]["info"] = function: 0000022BF25BB970
-- _G["log"]["ERROR"] = 8
-- _G["log"]["TIME_RELATIVE"] = 128
-- _G["log"]["TRACE"] = 256
-- _G["log"]["alert"] = function: 0000022BF25BB8F0
-- _G["log"]["MESSAGE"] = 0
-- _G["tostring"] = function: 0000023397DD50C0
-- _G["gcinfo"] = function: 0000023397DD4790 returned 66
-- _G["set_crew_member_seat_adjustment"] = function: 0000023397DDB2D0
-- _G["LockOn_Options"] = {}
-- _G["LockOn_Options"]["script_path"] = "C:\\Users\\cadre\\Saved Games\\DCS\\Mods/aircraft/A-29B/Cockpit/Scripts/"
-- _G["LockOn_Options"]["cockpit_language"] = "russian"
-- _G["LockOn_Options"]["common_script_path"] = "Scripts/Aircrafts/_Common/Cockpit/"
-- _G["LockOn_Options"]["date"] = {}
-- _G["LockOn_Options"]["date"]["year"] = 2236
-- _G["LockOn_Options"]["date"]["day"] = 22
-- _G["LockOn_Options"]["date"]["month"] = 4
-- _G["LockOn_Options"]["flight"] = {}
-- _G["LockOn_Options"]["flight"]["unlimited_fuel"] = false
-- _G["LockOn_Options"]["flight"]["g_effects"] = "realistic"
-- _G["LockOn_Options"]["flight"]["radio_assist"] = false
-- _G["LockOn_Options"]["flight"]["unlimited_weapons"] = false
-- _G["LockOn_Options"]["flight"]["external_view"] = true
-- _G["LockOn_Options"]["flight"]["easy_radar"] = false
-- _G["LockOn_Options"]["flight"]["easy_flight"] = false
-- _G["LockOn_Options"]["flight"]["external_labels"] = true
-- _G["LockOn_Options"]["flight"]["crash_recovery"] = true
-- _G["LockOn_Options"]["flight"]["immortal"] = false
-- _G["LockOn_Options"]["flight"]["tool_tips_enable"] = true
-- _G["LockOn_Options"]["flight"]["padlock"] = true
-- _G["LockOn_Options"]["flight"]["aircraft_switching"] = true
-- _G["LockOn_Options"]["screen"] = {}
-- _G["LockOn_Options"]["screen"]["height"] = 1080
-- _G["LockOn_Options"]["screen"]["aspect"] = 1.7777777910233
-- _G["LockOn_Options"]["screen"]["width"] = 1920
-- _G["LockOn_Options"]["cockpit"] = {}
-- _G["LockOn_Options"]["cockpit"]["mirrors"] = false
-- _G["LockOn_Options"]["cockpit"]["reflections"] = false
-- _G["LockOn_Options"]["cockpit"]["use_nightvision_googles"] = false
-- _G["LockOn_Options"]["cockpit"]["render_target_resolution"] = 1024
-- _G["LockOn_Options"]["time"] = {}
-- _G["LockOn_Options"]["time"]["hours"] = 12
-- _G["LockOn_Options"]["time"]["seconds"] = 0
-- _G["LockOn_Options"]["time"]["minutes"] = 0
-- _G["LockOn_Options"]["avionics_language"] = "native"
-- _G["LockOn_Options"]["measurement_system"] = "imperial"
-- _G["LockOn_Options"]["init_conditions"] = {}
-- _G["LockOn_Options"]["init_conditions"]["birth_place"] = "AIR_HOT"
-- _G["LockOn_Options"]["mission"] = {}
-- _G["LockOn_Options"]["mission"]["file_path"] = "stub"
-- _G["LockOn_Options"]["mission"]["description"] = "stub"
-- _G["LockOn_Options"]["mission"]["title"] = "stub"
-- _G["LockOn_Options"]["mission"]["campaign"] = ""
-- _G["os"] = {}
-- _G["os"]["getpid"] = function: 0000023397DD63B0
-- _G["os"]["date"] = function: 0000023397DD65F0
-- _G["os"]["getenv"] = function: 0000022BF25BBB30
-- _G["os"]["difftime"] = function: 0000023397DD6BF0
-- _G["os"]["remove"] = function: 0000023397DD6590
-- _G["os"]["time"] = function: 0000023397DD6320
-- _G["os"]["run_process"] = function: 0000023397DD6CE0
-- _G["os"]["clock"] = function: 0000023397DD4040
-- _G["os"]["open_uri"] = function: 0000023397DD6440
-- _G["os"]["rename"] = function: 0000023397DD6380
-- _G["os"]["execute"] = function: 0000022BF25BB770
-- _G["a_cockpit_perform_clickable_action"] = function: 0000023397DDB4B0
-- _G["basic_dump"] = function: 0000023397DDB9F0
-- _G["mount_vfs_model_path"] = function: 0000023397DDAF70
-- _G["c_cockpit_param_in_range"] = function: 0000023397DDB150
-- _G["getfenv"] = function: 0000023397DD4100
-- _G["USE_TERRAIN4"] = true
-- _G["list_cockpit_params"] = function: 0000023397DDB1B0
-- _G["pairs"] = function: 0000022BF25BB930
-- _G["get_param_handle"] = function: 0000023397DDAC10
-- _G["get_mission_route"] = function: 0000023397DDAAC0
-- get_mission_route = {}
-- get_mission_route[1] = {}
-- get_mission_route[1]["speed_locked"] = true
-- get_mission_route[1]["airdromeId"] = 27
-- get_mission_route[1]["action"] = "Fly Over Point"
-- get_mission_route[1]["alt_type"] = "BARO"
-- get_mission_route[1]["ETA"] = 0
-- get_mission_route[1]["alt"] = 2000
-- get_mission_route[1]["y"] = 760574.56102094
-- get_mission_route[1]["x"] = -124824.82468243
-- get_mission_route[1]["name"] = "DictKey_WptName_18"
-- get_mission_route[1]["ETA_locked"] = true
-- get_mission_route[1]["speed"] = 75
-- get_mission_route[1]["formation_template"] = ""
-- get_mission_route[1]["task"] = {}
-- get_mission_route[1]["task"]["id"] = "ComboTask"
-- get_mission_route[1]["task"]["params"] = {}
-- get_mission_route[1]["task"]["params"]["tasks"] = {}
-- get_mission_route[1]["type"] = "Turning Point"
-- get_mission_route[2] = {}
-- get_mission_route[2]["speed_locked"] = true
-- get_mission_route[2]["type"] = "TakeOff"
-- get_mission_route[2]["action"] = "From Runway"
-- get_mission_route[2]["alt_type"] = "BARO"
-- get_mission_route[2]["ETA"] = 0
-- get_mission_route[2]["y"] = 789260.82061283
-- get_mission_route[2]["x"] = -122670.06493381
-- get_mission_route[2]["name"] = "DictKey_WptName_19"
-- get_mission_route[2]["formation_template"] = ""
-- get_mission_route[2]["speed"] = 138.88888888889
-- get_mission_route[2]["ETA_locked"] = false
-- get_mission_route[2]["task"] = {}
-- get_mission_route[2]["task"]["id"] = "ComboTask"
-- get_mission_route[2]["task"]["params"] = {}
-- get_mission_route[2]["task"]["params"]["tasks"] = {}
-- get_mission_route[2]["alt"] = 267
-- _G["assert"] = function: 0000023397DD3D40
-- _G["get_input_devices"] = function: 0000023397DDA4F0
-- _G["tonumber"] = function: 0000023397DD4F10
-- _G["dbg_print"] = function: 0000023397DDA070
-- _G["io"] = {}
-- _G["io"]["read"] = function: 0000023397DD5F60
-- _G["io"]["write"] = function: 0000023397DD5E10
-- _G["io"]["close"] = function: 0000023397DD5D50
-- _G["io"]["lines"] = function: 0000023397DD5ED0
-- _G["io"]["flush"] = function: 0000023397DD6080
-- _G["io"]["open"] = function: 0000023397DD60E0
-- _G["io"]["__gc"] = function: 0000023397DD58D0
-- _G["unpack"] = function: 0000023397DD5510
-- _G["get_external_lights_reference"] = function: 0000023397DDB870
-- _G["lfs"] = {}
-- _G["lfs"]["normpath"] = function: 0000023397DD6B00
-- _G["lfs"]["locations"] = function: 0000023397DD69B0
-- _G["lfs"]["dir"] = function: 0000023397DD5E40
-- _G["lfs"]["tempdir"] = function: 0000023397DD68C0
-- _G["lfs"]["realpath"] = function: 0000023397DD64A0
-- _G["lfs"]["writedir"] = function: 0000023397DD6D10
-- _G["lfs"]["mkdir"] = function: 0000023397DD59C0
-- _G["lfs"]["currentdir"] = function: 0000023397DD5FF0
-- _G["lfs"]["add_location"] = function: 0000023397DD61D0
-- _G["lfs"]["attributes"] = function: 0000023397DD5A50
-- _G["lfs"]["create_lockfile"] = function: 0000023397DD64D0
-- _G["lfs"]["md5sum"] = function: 0000023397DD61A0
-- _G["lfs"]["del_location"] = function: 0000023397DD6170
-- _G["lfs"]["chdir"] = function: 0000023397DD5E70
-- _G["lfs"]["rmdir"] = function: 0000023397DD5B70
-- _G["GetSelf"] = function: 0000023397DDB750
-- _G["load"] = function: 0000023397DD4340
-- _G["dofile"] = function: 0000023397DD5060
-- _G["module"] = function: 0000023397DD5720                                        -- bad argument #1 to 'module' (string expected, got no value)
-- _G["get_aircraft_draw_argument_value"] = function: 0000023397DDA910
-- _G["a_cockpit_unlock_player_seat"] = function: 0000023397DDB510
-- _G["a_cockpit_lock_player_seat"] = function: 0000023397DDB930
-- _G["a_cockpit_pop_actor"] = function: 0000023397DDBE70
-- _G["_G"] = ->_G
-- _G["a_cockpit_push_actor"] = function: 0000023397DDBDE0
-- _G["ED_PUBLIC_AVAILABLE"] = true
-- _G["get_random_evenly"] = function: 0000023397DDAC70
-- _G["c_stop_wait_for_user"] = function: 0000023397DDBCC0
-- _G["list_indication"] = function: 0000023397DDB1E0
-- listindication = ""
-- listindication = {}
-- listindication["__index"] = {}
-- listindication["__index"]["sub"] = function: 0000022BFA168050
-- listindication["__index"]["upper"] = function: 0000022BFA168080
-- listindication["__index"]["len"] = function: 0000022BFA1680B0
-- listindication["__index"]["gfind"] = function: 0000022BFA167840
-- listindication["__index"]["rep"] = function: 0000022BFA167EA0
-- listindication["__index"]["find"] = function: 0000022BFA167B40
-- listindication["__index"]["match"] = function: 0000022BFA167E70
-- listindication["__index"]["char"] = function: 0000022BFA1759A0
-- listindication["__index"]["dump"] = function: 0000022BFA165BF0
-- listindication["__index"]["gmatch"] = function: 0000022BFA167840
-- listindication["__index"]["reverse"] = function: 0000022BFA167F00
-- listindication["__index"]["byte"] = function: 0000022BFA174590
-- listindication["__index"]["format"] = function: 0000022BFA1678A0
-- listindication["__index"]["gsub"] = function: 0000022BFA167BA0
-- listindication["__index"]["lower"] = function: 0000022BFA167720
-- _G["geo_to_lo_coords"] = function: 0000023397DDB480
-- _G["a_cockpit_param_save_as"] = function: 0000023397DDB180
-- _G["get_base_data"] = function: 0000023397DDA9D0
-- _G["coroutine"] = {}
-- _G["coroutine"]["resume"] = function: 0000023397DD4B20
-- _G["coroutine"]["yield"] = function: 0000023397DD5090
-- _G["coroutine"]["status"] = function: 0000023397DD49A0
-- _G["coroutine"]["wrap"] = function: 0000023397DD4D00
-- _G["coroutine"]["create"] = function: 0000023397DD42E0
-- _G["coroutine"]["running"] = function: 0000023397DD5450
-- _G["c_indication_txt_equal_to"] = function: 0000023397DDB2A0
-- _G["c_cockpit_param_is_equal_to_another"] = function: 0000023397DDB120
-- _G["switch_labels_off"] = function: 0000023397DDB420
-- _G["get_plugin_option_value"] = function: 0000023397DDAA60
-- _G["get_dcs_plugin_path"] = function: 0000023397DDAD60
-- _G["create_sound_host"] = function: 0000023397DDBAB0
-- _G["copy_to_mission_and_dofile"] = function: 0000023397DDAB20
-- _G["c_argument_in_range"] = function: 0000023397DDB210
-- _G["ED_FINAL_VERSION"] = true
-- _G["loadstring"] = function: 0000023397DD43A0
-- _G["dump"] = function: 0000023397DDC110
-- _G["get_terrain_related_data"] = function: 0000023397DDAD90
-- _G["get_aircraft_property_or_nil"] = function: 0000023397DDAE80                          call to ("net_animation") returned nil.
-- _G["get_aircraft_type"] = function: 0000023397DDAE50
-- _G["coroutine_create"] = function: 0000023397DDA2E0
-- _G["a_cockpit_remove_highlight"] = function: 0000023397DDAF10
-- _G["c_cockpit_highlight_visible"] = function: 0000023397DDB000
-- _G["a_cockpit_highlight_indication"] = function: 0000023397DDAEE0
-- _G["string"] = {}
-- _G["string"]["sub"] = function: 0000023397DD6DA0
-- _G["string"]["upper"] = function: 0000023397DD7580
-- _G["string"]["len"] = function: 0000023397DD6980
-- _G["string"]["gfind"] = function: 0000023397DD6800
-- _G["string"]["rep"] = function: 0000023397DD6B60
-- _G["string"]["find"] = function: 0000023397DD63E0
-- _G["string"]["match"] = function: 0000023397DD6AD0
-- _G["string"]["char"] = function: 0000023397DD4FA0
-- _G["string"]["dump"] = function: 0000023397DD5D20
-- _G["string"]["gmatch"] = function: 0000023397DD6800
-- _G["string"]["reverse"] = function: 0000023397DD7040
-- _G["string"]["byte"] = function: 0000023397DD4700
-- _G["string"]["format"] = function: 0000023397DD65C0
-- _G["string"]["gsub"] = function: 0000023397DD6A10
-- _G["string"]["lower"] = function: 0000023397DD6A70
-- _G["xpcall"] = function: 0000023397DD4DF0
-- _G["mount_vfs_path_to_mount_point"] = function: 0000023397DDAF40
-- _G["package"] = {}
-- _G["package"]["preload"] = {}
-- _G["package"]["loadlib"] = function: 0000023397DD4D60
-- _G["package"]["loaded"] = {}
-- _G["package"]["loaded"]["string"] = ->_G["string"]
-- _G["package"]["loaded"]["debug"] = {}
-- _G["package"]["loaded"]["debug"]["getupvalue"] = function: 0000023397DD7A90
-- _G["package"]["loaded"]["debug"]["debug"] = function: 0000023397DD7D60
-- _G["package"]["loaded"]["debug"]["sethook"] = function: 0000023397DD7AF0
-- _G["package"]["loaded"]["debug"]["getmetatable"] = function: 0000023397DD7A60
-- _G["package"]["loaded"]["debug"]["gethook"] = function: 0000023397DD7940
-- _G["package"]["loaded"]["debug"]["setmetatable"] = function: 0000023397DD7CA0
-- _G["package"]["loaded"]["debug"]["setlocal"] = function: 0000023397DD7C70
-- _G["package"]["loaded"]["debug"]["traceback"] = function: 0000023397DD7FD0
-- _G["package"]["loaded"]["debug"]["setfenv"] = function: 0000023397DD7F70
-- _G["package"]["loaded"]["debug"]["getinfo"] = function: 0000023397DD7F10
-- _G["package"]["loaded"]["debug"]["setupvalue"] = function: 0000023397DD7FA0
-- _G["package"]["loaded"]["debug"]["getlocal"] = function: 0000023397DD7C40
-- _G["package"]["loaded"]["debug"]["getregistry"] = function: 0000023397DD7D90
-- _G["package"]["loaded"]["debug"]["getfenv"] = function: 0000023397DD7A00
-- _G["package"]["loaded"]["lfs"] = ->_G["lfs"]
-- _G["package"]["loaded"]["_G"] = ->_G
-- _G["package"]["loaded"]["io"] = ->_G["io"]
-- _G["package"]["loaded"]["os"] = ->_G["os"]
-- _G["package"]["loaded"]["table"] = {}
-- _G["package"]["loaded"]["table"]["setn"] = function: 0000023397DD56C0
-- _G["package"]["loaded"]["table"]["insert"] = function: 0000023397DD5B10
-- _G["package"]["loaded"]["table"]["getn"] = function: 0000023397DD5BD0
-- _G["package"]["loaded"]["table"]["foreachi"] = function: 0000023397DD6050
-- _G["package"]["loaded"]["table"]["maxn"] = function: 0000023397DD5EA0
-- _G["package"]["loaded"]["table"]["foreach"] = function: 0000023397DD5C30
-- _G["package"]["loaded"]["table"]["concat"] = function: 0000023397DD5B40
-- _G["package"]["loaded"]["table"]["sort"] = function: 0000023397DD55A0
-- _G["package"]["loaded"]["table"]["remove"] = function: 0000023397DD5CC0
-- _G["package"]["loaded"]["math"] = {}
-- _G["package"]["loaded"]["math"]["log"] = function: 0000023397DD7220
-- _G["package"]["loaded"]["math"]["max"] = function: 0000023397DD7340
-- _G["package"]["loaded"]["math"]["acos"] = function: 0000023397DD7850
-- _G["package"]["loaded"]["math"]["huge"] = inf
-- _G["package"]["loaded"]["math"]["ldexp"] = function: 0000023397DD7130
-- _G["package"]["loaded"]["math"]["pi"] = 3.1415926535898
-- _G["package"]["loaded"]["math"]["cos"] = function: 0000023397DD6E90
-- _G["package"]["loaded"]["math"]["tanh"] = function: 0000023397DD7670
-- _G["package"]["loaded"]["math"]["pow"] = function: 0000023397DD6F20
-- _G["package"]["loaded"]["math"]["deg"] = function: 0000023397DD70D0
-- _G["package"]["loaded"]["math"]["tan"] = function: 0000023397DD79D0
-- _G["package"]["loaded"]["math"]["cosh"] = function: 0000023397DD70A0
-- _G["package"]["loaded"]["math"]["sinh"] = function: 0000023397DD7430
-- _G["package"]["loaded"]["math"]["random"] = function: 0000023397DD6F50
-- _G["package"]["loaded"]["math"]["randomseed"] = function: 0000023397DD77F0
-- _G["package"]["loaded"]["math"]["frexp"] = function: 0000023397DD7820
-- _G["package"]["loaded"]["math"]["ceil"] = function: 0000023397DD7070
-- _G["package"]["loaded"]["math"]["floor"] = function: 0000023397DD72E0
-- _G["package"]["loaded"]["math"]["rad"] = function: 0000023397DD7370
-- _G["package"]["loaded"]["math"]["abs"] = function: 0000023397DD7760
-- _G["package"]["loaded"]["math"]["sqrt"] = function: 0000023397DD7550
-- _G["package"]["loaded"]["math"]["modf"] = function: 0000023397DD6EC0
-- _G["package"]["loaded"]["math"]["asin"] = function: 0000023397DD6D70
-- _G["package"]["loaded"]["math"]["min"] = function: 0000023397DD7250
-- _G["package"]["loaded"]["math"]["mod"] = function: 0000023397DD77C0
-- _G["package"]["loaded"]["math"]["fmod"] = function: 0000023397DD77C0
-- _G["package"]["loaded"]["math"]["log10"] = function: 0000023397DD7790
-- _G["package"]["loaded"]["math"]["atan2"] = function: 0000023397DD7310
-- _G["package"]["loaded"]["math"]["exp"] = function: 0000023397DD78E0
-- _G["package"]["loaded"]["math"]["sin"] = function: 0000023397DD7520
-- _G["package"]["loaded"]["math"]["atan"] = function: 0000023397DD71F0
-- _G["package"]["loaded"]["log"] = ->_G["log"]
-- _G["package"]["loaded"]["coroutine"] = ->_G["coroutine"]
-- _G["package"]["loaded"]["package"] = ->_G["package"]
-- _G["package"]["loaders"] = {}
-- _G["package"]["loaders"][1] = function: 0000023397DD5120
-- _G["package"]["loaders"][2] = function: 0000022BF25BB730
-- _G["package"]["loaders"][3] = function: 0000023397DD5750
-- _G["package"]["loaders"][4] = function: 0000023397DD5180
-- _G["package"]["loaders"][5] = function: 0000023397DD51B0
-- _G["package"]["cpath"] = ".\\lua-?.dll;.\\?.dll;C:\\DCS World\\bin\\lua-?.dll;C:\\DCS World\\bin\\?.dll;"
-- _G["package"]["config"] = "\\\
-- _G["package"]["path"] = ".\\?.lua;C:\\DCS World\\bin\\lua\\?.lua;C:\\DCS World\\bin\\lua\\?\\init.lua;C:\\DCS World\\bin\\?.lua;C:\\DCS World\\bin\\?\\init.lua"
-- _G["package"]["seeall"] = function: 0000023397DD5420
-- _G["get_player_crew_index"] = function: 0000023397DDAFD0
-- _G["_VERSION"] = "Lua 5.1"
-- _G["get_option_value"] = function: 0000023397DDAC40
-- _G["a_cockpit_highlight"] = function: 0000023397DDB0C0
-- _G["a_cockpit_highlight_position"] = function: 0000023397DDAEB0
-- _G["get_aircraft_property"] = function: 0000023397DDB3C0
-- _G["table"] = ->_G["package"]["loaded"]["table"]
-- _G["get_aircraft_mission_data"] = function: 0000023397DDA940                                     returned nil
-- _G["get_clickable_element_reference"] = function: 0000023397DDADF0
-- _G["require"] = function: 0000023397DD5660
-- _G["find_viewport"] = function: 0000023397DDB300
-- _G["c_cockpit_param_equal_to"] = function: 0000023397DDB0F0
-- _G["get_absolute_model_time"] = function: 0000023397DDAFA0
-- _G["setmetatable"] = function: 0000023397DD4E80
-- _G["next"] = function: 0000023397DD4400
-- _G["_ED_VERSION"] = "DCS/2.5.6.60966 (x86_64; Windows NT 10.0.18363)"
-- _G["get_cockpit_draw_argument_value"] = function: 0000023397DDAD30
-- _G["set_aircraft_draw_argument_value"] = function: 0000023397DDAD00
-- _G["ipairs"] = function: 0000022BF25BB630
-- _G["UTF8_substring"] = function: 0000023397DDB330
-- _G["get_random_orderly"] = function: 0000023397DDB360
-- _G["rawequal"] = function: 0000023397DD4670
-- _G["make_default_activity"] = function: 0000023397DDB660
-- _G["collectgarbage"] = function: 0000023397DD4520
-- _G["load_mission_file"] = function: 0000023397DDA160
-- _G["getmetatable"] = function: 0000023397DD4280
-- _G["get_plugin_option"] = function: 0000023397DDB3F0
-- _G["dispatch_action"] = function: 0000023397DDABE0
-- _G["c_start_wait_for_user"] = function: 0000023397DDB450
-- _G["track_is_reading"] = function: 0000023397DDB390
-- _G["print_message_to_user"] = function: 0000023397DDAA00
-- _G["lo_to_geo_coords"] = function: 0000023397DDB270
-- _G["rawset"] = function: 0000023397DD4A00
-- _G["mount_vfs_texture_path"] = function: 0000023397DDABB0
-- _G["track_is_writing"] = function: 0000023397DDAAF0
-- _G["mount_vfs_texture_archives"] = function: 0000023397DDAB50
-- _G["a_start_listen_event"] = function: 0000023397DDB090
-- _G["save_to_mission"] = function: 0000023397DDA580
-- _G["print"] = function: 0000023397DD4C70
-- _G["math"] = ->_G["package"]["loaded"]["math"]
-- _G["get_non_sim_random_evenly"] = function: 0000023397DDACA0
-- _G["pcall"] = function: 0000023397DD4580
-- _G["newproxy"] = function: 0000022BF25BC030
-- _G["create_sound"] = function: 0000023397DDC0B0
-- _G["type"] = function: 0000023397DD4AC0
-- _G["get_UIMainView"] = function: 0000023397DDB4E0
-- _G["get_multimonitor_preset_name"] = function: 0000023397DDAB80
-- _G["select"] = function: 0000023397DD54B0
-- _G["_ARCHITECTURE"] = "x86_64"
-- _G["do_mission_file"] = function: 0000023397DDA520
-- _G["rawget"] = function: 0000023397DD47C0
-- _G["copy_to_mission_and_get_buffer"] = function: 0000023397DDAE20
-- _G["a_start_listen_command"] = function: 0000023397DDB030
-- _G["debug"] = ->_G["package"]["loaded"]["debug"]
-- _G["setfenv"] = function: 0000023397DD5030
-- _G["get_model_time"] = function: 0000023397DDAA90
-- _G["GetDevice"] = function: 0000023397DDB9C0
-- _G["error"] = function: 0000023397DD3EF0
-- _G["loadfile"] = function: 0000023397DD4DC0
-- __G = nil


-- list_cockpit_params = "

-- RIGHT_BRAKE_PEDAL:0.000000\
-- STORM_LIGHT:0.000000\
-- ADHSI_HDG_SEL:0.000000\
-- WPN_GUNS_L:0.000000\
-- EICAS_SPD_BRK_TXT:0.000000\
-- HDD002_PFD:0.000000\
-- BASE_SENSOR_YAW_RATE:0.000000\
-- EICAS_ERROR6_TEXT:0.000000\
-- EICAS_NG:0.000000\
-- CSL_BACKLIGHT:0.000000\
-- PNL_BACKLIGHT:0.000000\
-- HUD_VOR_MAG:0.000000\
-- CMFDNumber:0.000000\
-- CMFD1_BRIGHT:1.000000\
-- ADHSI_VOR_SEC:0.000000\
-- ADHSI_AP_ROL:0.000000\
-- EICAS_ERROR8_COLOR:0.000000\
-- HUD_PL_SLIDE:0.000000\
-- HUD_DRIFT_CO:0.000000\
-- ADHSI_FYT_DTK_HDG:0.000000\
-- EICAS_BAT_TEMP_COR:0.000000\
-- HUD_RDY_S:0.000000\
-- HIDE_STICK:0.000000\
-- ADHSI_GPS_SEC:0.000000\
-- EICAS_ERROR6_COLOR:0.000000\
-- EICAS_TQ_COR:0.000000\
-- ELEC_AVIONICS_OK:0.000000\
-- HUD_RI_ROLL:0.000000\
-- AVIONICS_TURN_RATE:0.000000\
-- CHART_LIGHT:0.000000\
-- GEAR_HANDLE_LIGHT:0.000000\
-- ADHSI_AP_PIT:0.000000\
-- ELEC_AVIONICS_EMEGENCY_OK:0.000000\
-- ELEC_MAIN_BAR_OK:0.000000\
-- ELEC_EMERGENCY_OK:0.000000\
-- IAS:0.000000\
-- ELEC_EMERGENCY_RESERVE_OK:0.000000\
-- EICAS_FUEL_INT_ROT:0.000000\
-- HUD_WARN_ON:0.000000\
-- AVIONICS_IAS:0.000000\
-- AVIONICS_ALT:0.000000\
-- BFI_MB:0.000000\
-- EICAS_TQ_OPT_ROT:0.000000\
-- AVIONICS_VV:0.000000\
-- ANS_MODE:0.000000\
-- AVIONICS_HDG:0.000000\
-- AVIONICS_RALT:0.000000\
-- EICAS_TQ:0.000000\
-- hdd_002_brightness:0.000000\
-- EICAS_TQ_ROT:0.000000\
-- EICAS_TQ_REQ_ROT:0.000000\
-- EICAS_T5:0.000000\
-- EICAS_T5_ROT:0.000000\
-- EICAS_T5_COR:0.000000\
-- EICAS_OIL_PRESS:0.000000\
-- EICAS_OIL_PRESS_COR:0.000000\
-- EICAS_OIL_TEMP:0.000000\
-- ADHSI_VOR_DIST:0.000000\
-- EICAS_OIL_TEMP_COR:0.000000
-- GEAR_NOSE_LIGHT:0.000000\
-- LEFT_BRAKE_PEDAL:0.000000\
-- WARNING_LIGHT:0.000000\
-- CAUTION_LIGHT:0.000000\
-- HUD_AOA:0.000000\
-- FIRE_LIGHT:0.000000\
-- EICAS_NG_COR:0.000000\
-- PBRAKE_LIGHT:0.000000\
-- UFCP_DA:0.000000\
-- GEAR_LEFT_LIGHT:0.000000\
-- GEAR_RIGHT_LIGHT:0.000000\
-- ARC51-FREQ-PRESET:0.000000\
-- ADHSI_TURN_RATE_ON:0.000000\

-- BASE_SENSOR_WOW_NOSE_GEAR:0.000000\
-- BASE_SENSOR_LEFT_THROTTLE_POS:0.000000\
-- BASE_SENSOR_LEFT_ENGINE_TEMP_BEFORE_TURBINE:320.000000\
-- BASE_SENSOR_LEFT_ENGINE_FUEL_CONSUPMTION:0.000000\
-- BASE_SENSOR_ROLL:-0.000000\
-- BASE_SENSOR_MAG_HEADING:7.385789\
-- BASE_SENSOR_RADALT:1569.383789\
-- BASE_SENSOR_PITCH:0.094513\
-- BASE_SENSOR_NOSE_GEAR_UP:1.000000\
-- BASE_SENSOR_AOS:0.000000\
-- BASE_SENSOR_STICK_PITCH_NORMED:0.176197\
-- BASE_SENSOR_BAROALT:1845.759766\
-- BASE_SENSOR_AOA:0.094513\
-- BASE_SENSOR_IAS:67.551605\
-- BASE_SENSOR_VERTICAL_SPEED:0.000000\
-- BASE_SENSOR_TAS:75.000000\
-- BASE_SENSOR_VERTICAL_ACCEL:1.000000\
-- BASE_SENSOR_FLAPS_POS:0.000000\
-- BASE_SENSOR_HELI_CORRECTION:0.000000\
-- BASE_SENSOR_LEFT_THROTTLE_RAW_CONTROL:0.000000\
-- BASE_SENSOR_MACH:0.225561\
-- BASE_SENSOR_LEFT_GEAR_UP:1.000000\
-- BASE_SENSOR_HORIZONTAL_ACCEL:0.000000\
-- BASE_SENSOR_LATERAL_ACCEL:0.000000\
-- BASE_SENSOR_ROLL_RATE:0.000000\
-- BASE_SENSOR_PITCH_RATE:0.000000\
-- BASE_SENSOR_LEFT_GEAR_DOWN:0.000000\
-- BASE_SENSOR_HEADING:-1.495822\
-- BASE_SENSOR_CANOPY_STATE:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_TEMP_BEFORE_TURBINE:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_FUEL_CONSUMPTION:0.000000\
-- BASE_SENSOR_LEFT_ENGINE_RPM:64.599998\
-- BASE_SENSOR_RUDDER_POS:0.000000\
-- BASE_SENSOR_RIGHT_ENGINE_RPM:0.000000\
-- BASE_SENSOR_WOW_RIGHT_GEAR:0.000000\
-- BASE_SENSOR_WOW_LEFT_GEAR:0.000000\
-- BASE_SENSOR_RIGHT_GEAR_DOWN:0.000000\
-- BASE_SENSOR_NOSE_GEAR_DOWN:0.000000\
-- BASE_SENSOR_RIGHT_GEAR_UP:1.000000\
-- BASE_SENSOR_SPEED_BRAKE_POS:0.000000\
-- BASE_SENSOR_GEAR_HANDLE:0.000000\
-- BASE_SENSOR_ALTIMETER_ATMO_PRESSURE_HG:0.000000\
-- BASE_SENSOR_STICK_ROLL_POS:17.619747\
-- BASE_SENSOR_STICK_PITCH_POS:0.000000\
-- BASE_SENSOR_RIGHT_THROTTLE_POS:0.000000\
-- BASE_SENSOR_HELI_COLLECTIVE:0.000000\
-- BASE_SENSOR_CANOPY_POS:0.000000\
-- BASE_SENSOR_FLAPS_RETRACTED:1.000000\
-- BASE_SENSOR_FUEL_TOTAL:512.825012\
-- BASE_SENSOR_STICK_ROLL_NORMED:0.000000\
-- BASE_SENSOR_RUDDER_NORMED:0.000000\
-- BASE_SENSOR_RIGHT_THROTTLE_RAW_CONTROL:0.000000\

-- EJECTION_BLOCKED_0:0.000000\
-- EJECTION_INITIATED_0:-1.000000\
-- EJECTION_BLOCKED_1:0.000000\
-- EJECTION_INITIATED_1:-1.000000\

-- WS_DLZ_MAX:-1.000000\
-- WS_GUN_PIPER_SPAN:0.000000\
-- WS_IR_MISSILE_TARGET_ELEVATION:0.000000\
-- WS_ROCKET_PIPER_ELEVATION:0.000000\
-- WS_ROCKET_PIPER_AVAILABLE:0.000000\

-- _list_cockpit_params = {}
-- _list_cockpit_params["__index"] = {}
-- _list_cockpit_params["__index"]["sub"] = function: 0000023397D9E380
-- _list_cockpit_params["__index"]["upper"] = function: 0000023397D9ECE0
-- _list_cockpit_params["__index"]["len"] = function: 0000023397D9EA40
-- _list_cockpit_params["__index"]["gfind"] = function: 0000023397D9E860
-- _list_cockpit_params["__index"]["rep"] = function: 0000023397D9E290
-- _list_cockpit_params["__index"]["find"] = function: 0000023397D9E9E0
-- _list_cockpit_params["__index"]["match"] = function: 0000023397D9E200
-- _list_cockpit_params["__index"]["char"] = function: 0000023397D9D4B0
-- _list_cockpit_params["__index"]["dump"] = function: 0000023397D9CA90
-- _list_cockpit_params["__index"]["gmatch"] = function: 0000023397D9E860
-- _list_cockpit_params["__index"]["reverse"] = function: 0000023397D9E2F0
-- _list_cockpit_params["__index"]["byte"] = function: 0000023397D9C850
-- _list_cockpit_params["__index"]["format"] = function: 0000023397D9E3E0
-- _list_cockpit_params["__index"]["gsub"] = function: 0000023397D9E9B0
-- _list_cockpit_params["__index"]["lower"] = function: 0000023397D9E74



-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4] = {}
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["_file"] = "./CoreMods/aircraft/AircraftWeaponPack/aim9_family.lua"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Picture"] = "us_AIM-9L.png"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["PictureBlendColor"] = "0xffffffff"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["displayName"] = "AIM-9M Sidewinder IR AAM"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["_origin"] = "AircraftWeaponPack"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Count"] = 1
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["category"] = 4
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Elements"] = {}
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Elements"][1] = {}
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Elements"][1]["ShapeName"] = "AIM-9"
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Weight"] = 86.64
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["attribute"] = {}
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["attribute"][1] = 4
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["attribute"][2] = 4
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["attribute"][3] = 7
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["attribute"][4] = 22
-- _G["plugins_by_id"]["AircraftWeaponPack"]["loadout"][4]["Cx_pil"] = 0.000458984375
-- 


--[[

strings from CockpitBase.dll starting with "av"  (for avionics?):

avA11Clock nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avA2GRadar fails

avAChS_1 nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avADF fails

avADI
GetSelf meta["__index"]["get_sideslip"] = function: 00000000CE41A760
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE41A280
GetSelf meta["__index"]["get_bank"] = function: 00000000CE41A6C0
GetSelf meta["__index"]["listen_event"] = function: 00000000CE41A370
GetSelf meta["__index"]["get_pitch"] = function: 00000000CE41A410
GetSelf meta["__index"]["listen_command"] = function: 00000000CE41A2D0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE41A190

avAGB_3K

avAHRS

avAN_ALE_40V

avAN_ALR69V

avA_RV_Altimeter

avActuator

avActuator_BasicTimer

avAirDrivenDirectionalGyro

avAirDrivenTurnIndicator

avArcadeRadar

avArtificialHorizon Fails

avArtificialHorizont_AN5736 Nothing Special

avAutostartDevice

avAvionicsDataProxyDefault fails

avBaseARC fails

avBaseASP_3 nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avBaseIKP
GetSelf meta["__index"] = {}
GetSelf meta["__index"]["get_sideslip"] = function: 00000000CC825190
GetSelf meta["__index"]["listen_command"] = function: 00000000CC824D00
GetSelf meta["__index"]["listen_event"] = function: 00000000CC824DA0
GetSelf meta["__index"]["get_attitude_warn_flag_val"] = function: 00000000CC8252D0
GetSelf meta["__index"]["get_pitch_steering"] = function: 00000000CC825820
GetSelf meta["__index"]["get_track_deviation"] = function: 00000000CC825960
GetSelf meta["__index"]["get_airspeed_deviation"] = function: 00000000CC8258C0
GetSelf meta["__index"]["get_height_deviation"] = function: 00000000CC825A00
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC824CB0
GetSelf meta["__index"]["get_bank_steering"] = function: 00000000CC825780
GetSelf meta["__index"]["get_pitch"] = function: 00000000CC824E40
GetSelf meta["__index"]["get_steering_warn_flag_val"] = function: 00000000CC825230
GetSelf meta["__index"]["get_bank"] = function: 00000000CC8250F0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC824BC0

avBaseRadio fails

avBasicElectric fails

avBasicElectricInterface fails

avBasicHearingSensitivityInterface
GetSelf meta["__index"]["listen_event"] = function: 00000000CDB95870
GetSelf meta["__index"]["listen_command"] = function: 00000000CDB957D0
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CDB95780
GetSelf meta["__index"]["SetCommand"] = function: 00000000CDB95690

avBasicLightSystem fails

avBasicOxygenSystemInterface fails

avBasicSAI

avBasicSensor

avBasicSensor_SearchTimer

avBreakable fails

avBreakable_BasicTimer

avBreakable_WorkTimeFailureTimer

avChaffFlareContainer

avChaffFlareDispencer

avCommunicator fails

avDNS

avDevice

avDevice_BasicTimer

avDirectionalGyro_AN5735
dev = {}
dev["link"] = userdata: 0000026A86447BC0
_dev = {}
_dev["__index"] = {}
_dev["__index"]["listen_event"] = function: 0000026AAB554C60
_dev["__index"]["listen_command"] = function: 0000026AAB555050
_dev["__index"]["performClickableAction"] = function: 0000026AAB555470
_dev["__index"]["SetCommand"] = function: 0000026AAB5555F0


avDispenseProgram

avEkranControl

avElectricSourceParamDriven fails

avElectricallyHeldSwitch

avElectroMagneticDetector

avFMProxyBase fails

avHSI Failed to create instance of avHSI by unknown reason

avHUD Failed to create instance of avHud by unknown reason

avHUD_SEI31 Failed to create instance of avHUD_SEI31 by unknown reason

avHelmet

avIFF_APX_72

avIFF_FuG25

avILS
dev = {}
dev["link"] = userdata: 0000026B08677440
_dev = {}
_dev["__index"] = {}
_dev["__index"]["listen_event"] = function: 0000026A3953B310
_dev["__index"]["listen_command"] = function: 0000026A3953B220
_dev["__index"]["performClickableAction"] = function: 0000026A3953B2E0
_dev["__index"]["SetCommand"] = function: 0000026A3953B700

avILS_AN_ARN108
dev = {}
dev["link"] = userdata: 0000026B08677440
_dev = {}
_dev["__index"] = {}
_dev["__index"]["listen_event"] = function: 0000026B9C029F40
_dev["__index"]["listen_command"] = function: 0000026B9C0299A0
_dev["__index"]["performClickableAction"] = function: 0000026B9C029AF0
_dev["__index"]["SetCommand"] = function: 0000026B9C02A120

avINS

avIRSensor

avIntercom:
GetSelf meta["__index"]["listen_command"] = function: 00000000CEBA3BD0
GetSelf meta["__index"]["listen_event"] = function: 00000000CEBA3C70
GetSelf meta["__index"]["set_communicator"] = function: 00000000CEBA3FC0
GetSelf meta["__index"]["is_communicator_available"] = function: 00000000CEBA3D10
GetSelf meta["__index"]["set_voip_mode"] = function: 00000000CEBA4060
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CEBA3B80
GetSelf meta["__index"]["get_noise_level"] = function: 00000000CEBA4100
GetSelf meta["__index"]["get_signal_level"] = function: 00000000CEBA41A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CEBA3A90


avIntercomWWII
GetSelf meta["__index"]["listen_command"] = function: 00000000CC122DD0
GetSelf meta["__index"]["listen_event"] = function: 00000000CC122E70
GetSelf meta["__index"]["set_communicator"] = function: 00000000CC1231C0
GetSelf meta["__index"]["is_communicator_available"] = function: 00000000CC122F10
GetSelf meta["__index"]["set_voip_mode"] = function: 00000000CC123260
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC122D80
GetSelf meta["__index"]["get_noise_level"] = function: 00000000CC123300
GetSelf meta["__index"]["get_signal_level"] = function: 00000000CC1233A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC122C90

avJammerInterface

avK14GunSight

avKneeboard nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avKneeboardZoneObject

avLaserSpotDetector

avLinkToTargetResponder

avLuaDevice
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC4194C0
GetSelf meta["__index"]["SetDamage"] = function: 00000000CC419650
GetSelf meta["__index"]["listen_event"] = function: 00000000CC4195B0
GetSelf meta["__index"]["listen_command"] = function: 00000000CC419510
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC4193D0

avLuaRegistrable fails

avMLWS

avMagneticCompass

avMarkerReceiver

avMechCompass

avMechanicAccelerometer

avMechanicClock

avMissionTargetManager

avMovingMap

avMovingMapPoint

avMovingMap_Cursor

avNightVisionGoggles

avPadlock


avPlatform fails

avPlayerTaskHandler

avR73seeker

avRWR fails

avR_828

avRadarAltimeterBase fails

avRangefinder

avReceiver fails

avRemoteCompass_AN5730

avRemoteMagnetCompass

avRippReleaseCapable

avRollPitchGyro

avSNS

avSNS_GPS_GNSS_Listener

avSNS_GPS_Listener

avSidewinderSeeker fails

avSimpleAirspeedIndicator

avSimpleAltimeter       Crashes
2021-03-29 02:18:33.295 ERROR   COCKPITBASE: devices_keeper::link_all: unable to find link source 'FM_Proxy' for device 'TEST'

avSimpleElectricSystem
GetSelf meta["__index"]["get_DC_Bus_1_voltage"] = function: 00000000CD4E73D0
GetSelf meta["__index"]["get_DC_Bus_2_voltage"] = function: 00000000CD4E7470
GetSelf meta["__index"]["listen_command"] = function: 00000000CD4E68B0
GetSelf meta["__index"]["listen_event"] = function: 00000000CD4E6950
GetSelf meta["__index"]["get_AC_Bus_1_voltage"] = function: 00000000CD4E6E80
GetSelf meta["__index"]["AC_Generator_1_on"] = function: 00000000CD4E6CA0
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD4E6860
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD4E69F0
GetSelf meta["__index"]["AC_Generator_2_on"] = function: 00000000CD4E6D40
GetSelf meta["__index"]["get_AC_Bus_2_voltage"] = function: 00000000CD4E7330
GetSelf meta["__index"]["DC_Battery_on"] = function: 00000000CD4E6DE0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD4E6770

avSimpleMachIndicator

avSimpleRWR
GetSelf meta["__index"]["reset"] = function: 00000000CD1FFE80
GetSelf meta["__index"]["set_power"] = function: 00000000CD1FFE30
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD1FF950
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD1FFAE0
GetSelf meta["__index"]["listen_event"] = function: 00000000CD1FFA40
GetSelf meta["__index"]["get_power"] = function: 00000000CD1FFD90
GetSelf meta["__index"]["listen_command"] = function: 00000000CD1FF9A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD1FF860

avSimpleRadar

avSimpleRadarTimer

avSimpleTurnSlipIndicator fails

avSimpleVariometer

avSimpleWeaponSystem
GetSelf meta["__index"]["get_station_info"] = function: 00000000CD517F60
GetSelf meta["__index"]["listen_event"] = function: 00000000CD517300
GetSelf meta["__index"]["drop_flare"] = function: 00000000CD518140
GetSelf meta["__index"]["set_ECM_status"] = function: 00000000CD518B30
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD517210
GetSelf meta["__index"]["get_ECM_status"] = function: 00000000CD518A90
GetSelf meta["__index"]["launch_station"] = function: 00000000CD5176F0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD517120
GetSelf meta["__index"]["get_chaff_count"] = function: 00000000CD5180A0
GetSelf meta["__index"]["emergency_jettison"] = function: 00000000CD517E20
GetSelf meta["__index"]["set_target_range"] = function: 00000000CD517CE0
GetSelf meta["__index"]["set_target_span"] = function: 00000000CD517790
GetSelf meta["__index"]["get_flare_count"] = function: 00000000CD518000
GetSelf meta["__index"]["get_target_range"] = function: 00000000CD517D80
GetSelf meta["__index"]["get_target_span"] = function: 00000000CD517830
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD5173A0
GetSelf meta["__index"]["drop_chaff"] = function: 00000000CD5189F0
GetSelf meta["__index"]["select_station"] = function: 00000000CD517650
GetSelf meta["__index"]["listen_command"] = function: 00000000CD517260
GetSelf meta["__index"]["emergency_jettison_rack"] = function: 00000000CD517EC0

avSlipBall

avSpot_SearchTimer

avTACAN fails

avTACAN_AN_ARN118

avTVSensor

avTW_Prime

avTransponder

avUGR_4K

avUHF_ARC_164
GetSelf meta["__index"]["listen_command"] = function: 00000000CC631830
GetSelf meta["__index"]["is_frequency_in_range"] = function: 00000000CC632290
GetSelf meta["__index"]["set_frequency"] = function: 00000000CC631C20
GetSelf meta["__index"]["is_on"] = function: 00000000CC631DE0
GetSelf meta["__index"]["get_frequency"] = function: 00000000CC631970
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC6317E0
GetSelf meta["__index"]["set_modulation"] = function: 00000000CC631CC0
GetSelf meta["__index"]["set_channel"] = function: 00000000CC631D60
GetSelf meta["__index"]["listen_event"] = function: 00000000CC6318D0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC6316F0

avUV_26

avVHF_ARC_186:
GetSelf meta["__index"]["listen_command"] = function: 00000000CE503600
GetSelf meta["__index"]["is_frequency_in_range"] = function: 00000000CE504030
GetSelf meta["__index"]["set_frequency"] = function: 00000000CE5039F0
GetSelf meta["__index"]["is_on"] = function: 00000000CE503B80
GetSelf meta["__index"]["get_frequency"] = function: 00000000CE503740
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE5035B0
GetSelf meta["__index"]["set_modulation"] = function: 00000000CE503A90
GetSelf meta["__index"]["set_channel"] = function: 00000000CE503B30
GetSelf meta["__index"]["listen_event"] = function: 00000000CE5036A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE5034C0


avVHF_FuG16ZY

avVHF_SCR_522A

avVMS fails

avVMS_ALMAZ_UP

avWeap_ReleaseTimer_Activity






--]]


-- getAngleOfAttack
-- getAngleOfSlide
-- getBarometricAltitude
-- getCanopyPos
-- getCanopyState
-- getEngineLeftFuelConsumption
-- getEngineLeftRPM
-- getEngineLeftTemperatureBeforeTurbine
-- getEngineRightFuelConsumption
-- getEngineRightRPM
-- getEngineRightTemperatureBeforeTurbine
-- getFlapsPos
-- getFlapsRetracted
-- getHeading
-- getHorizontalAcceleration
-- getIndicatedAirSpeed
-- getLandingGearHandlePos
-- getLateralAcceleration
-- getLeftMainLandingGearDown
-- getLeftMainLandingGearUp
-- getMachNumber
-- getMagneticHeading
-- getNoseLandingGearDown
-- getNoseLandingGearUp
-- getPitch
-- getRadarAltitude
-- getRateOfPitch
-- getRateOfRoll
-- getRateOfYaw
-- getRightMainLandingGearDown
-- getRightMainLandingGearUp
-- getRoll
-- getRudderPosition
-- getSpeedBrakePos
-- getSelfAirspeed
-- getSelfCoordinates
-- getSelfVelocity
-- getStickPitchPosition
-- getStickRollPosition
-- getThrottleLeftPosition
-- getThrottleRightPosition
-- getTotalFuelWeight
-- getTrueAirSpeed
-- getVerticalAcceleration
-- getVerticalVelocity
-- getWOW_LeftMainLandingGear
-- getWOW_NoseLandingGear
-- getWOW_RightMainLandingGear




-- _G["Factory"] = {}
-- _G["Factory"]["createClass"] = function: 000001BF4D80B4A0
-- _G["Factory"]["clone"] = function: 000001BF4D80AF60
-- _G["Factory"]["_NAME"] = "Factory"
-- _G["Factory"]["_PACKAGE"] = ""
-- _G["Factory"]["registerWidget"] = function: 000001BF4D80ADE0
-- _G["Factory"]["_M"] = ->_G["Factory"]
-- _G["Factory"]["create"] = function: 000001BF4D80B260
-- _G["Factory"]["setBaseClass"] = function: 000001BF4D80B5F0
