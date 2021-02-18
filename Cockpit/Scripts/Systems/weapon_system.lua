dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("weapon: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local ir_missile_lock_param = get_param_handle("WS_IR_MISSILE_LOCK")
local ir_missile_az_param = get_param_handle("WS_IR_MISSILE_TARGET_AZIMUTH")
local ir_missile_el_param = get_param_handle("WS_IR_MISSILE_TARGET_ELEVATION")
local ir_missile_des_az_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH")
local ir_missile_des_el_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION")

local wpn_ej_timeout = -3

function update()
    -- E-J
    if wpn_ej_timeout ~= -3 then
        wpn_ej_timeout = wpn_ej_timeout - update_time_step
        if wpn_ej_timeout <= 0 then 
            if get_avionics_onground() ~= 1 then
                if wpn_ej_timeout <= -2.9 then
                    wpn_ej_timeout = -3
                    local cmfd = GetDevice(devices.CMFD)
                    if cmfd ~= nill then
                        cmfd:performClickableAction(device_commands.CMFD1OSS1, -200, false)
                    end
                elseif wpn_ej_timeout <= -0.4 then
                    if get_wpn_sto_jet(4) == 1 then 
                        set_wpn_sto_jet(4,0)
                        dev:emergency_jettison(3)
                        dev:emergency_jettison_rack(3)
                    end
                elseif wpn_ej_timeout <= -0.3 then
                    if get_wpn_sto_jet(2) == 1 then 
                        set_wpn_sto_jet(2,0)
                        dev:emergency_jettison(1)
                        dev:emergency_jettison_rack(1)
                    end
                elseif wpn_ej_timeout <= -0.2 then
                    if get_wpn_sto_jet(3) == 1 then 
                        set_wpn_sto_jet(3,0)
                        dev:emergency_jettison(2)
                        dev:emergency_jettison_rack(2)
                    end
                elseif wpn_ej_timeout <= -0.1 then
                    if get_wpn_sto_jet(5) == 1 then 
                        set_wpn_sto_jet(5,0)
                        dev:emergency_jettison(4)
                        dev:emergency_jettison_rack(4)
                    end
                elseif wpn_ej_timeout <= 0.0 then
                    if get_wpn_sto_jet(1) == 1 then 
                        set_wpn_sto_jet(1,0)
                        dev:emergency_jettison(0)
                        dev:emergency_jettison_rack(0)
                    end
                end
            end
        end
    end

    if ir_missile_lock_param:get() == 1 then
        print_message_to_user("AZ:" .. ir_missile_az_param:get() .. " EL:" .. ir_missile_el_param:get())
        dev:launch_station(0)
    end

end

function post_initialize()
    startup_print("weapon: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    dev:performClickableAction(device_commands.Mass, 0, true)
    dev:performClickableAction(device_commands.LateArm, -1, true)
    startup_print("weapon: postinit end")
end







dev:listen_command(device_commands.Mass)
dev:listen_command(device_commands.LateArm)
dev:listen_command(device_commands.Salvo)

local station = 0
function SetCommand(command,value)
    print_message_to_user("weapon: command "..tostring(command).." = "..tostring(value))
    if command==74 then
        for i=0,5 do
            local text = dump("wpn"..i, dev:get_station_info(i))
            print_message_to_user(text)
            log.info("\n"..text)
            -- dev:launch_station(i)
            local text = dump("wpn", getmetatable(dev))
            print_message_to_user(text)
            log.info("\n"..text)
            end
    elseif command == 176 then
        station =  (station + 1) % 6
        print_message_to_user("Station: "..station)
        dev:select_station(station)
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    elseif command == 136 then
        dev:drop_flare()
        print_message_to_user(dump("wpn"..station, dev:get_station_info(station)))
    elseif command == 79 then
        dev:drop_chaff()
        dev:launch_station(station)
    elseif command == 346 then
    elseif command == device_commands.Mass then
        WPN_MASS:set(value)
    elseif command == device_commands.LateArm then
        WPN_LATEARM:set(value)
    elseif command == device_commands.Salvo then
        if value == 1 then
            local cmfd = GetDevice(devices.CMFD)
            if cmfd ~= nill then
                cmfd:performClickableAction(device_commands.CMFD1OSS1, -100, false)
                wpn_ej_timeout = 0.5;
            end
        elseif value == 0 then
            if wpn_ej_timeout > 0 then 
                wpn_ej_timeout = -3  -- abort E-J
                for i=1,5 do
                    set_wpn_sto_jet(i-1,0)
                end
            end
            
        end
    end
end


startup_print("weapon: load end")
need_to_be_closed = false -- close lua state after initialization


-- WS_GUN_PIPER_SPAN:0.015000
-- WS_DLZ_MAX:-1.000000
-- WS_IR_MISSILE_TARGET_ELEVATION:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION:0.00000
-- WS_IR_MISSILE_LOCK:0.000000
-- WS_IR_MISSILE_TARGET_AZIMUTH:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH:0.000000
-- WS_GUN_PIPER_AVAILABLE:0.000000
-- WS_GUN_PIPER_AZIMUTH:0.000000
-- WS_GUN_PIPER_ELEVATION:0.000000
-- WS_TARGET_RANGE:1000.000000
-- WS_TARGET_SPAN:15.000000
-- WS_ROCKET_PIPER_AVAILABLE:0.000000
-- WS_ROCKET_PIPER_AZIMUTH:0.000000
-- WS_ROCKET_PIPER_ELEVATION:0.000000
-- WS_DLZ_MIN:-1.000000

-- wpn = {}
-- wpn["__index"] = {}
-- wpn["__index"]["get_station_info"] = function: 0000023264DB7B50
-- wpn["__index"]["listen_event"] = function: 0000023264DB6C80
-- wpn["__index"]["drop_flare"] = function: 0000023264DB7BE0
-- wpn["__index"]["set_ECM_status"] = function: 0000023264DB7CA0
-- wpn["__index"]["performClickableAction"] = function: 0000023264DB6F80
-- wpn["__index"]["get_ECM_status"] = function: 0000023264DB77F0
-- wpn["__index"]["launch_station"] = function: 0000023264DB6D40
-- wpn["__index"]["SetCommand"] = function: 0000023264DB71F0
-- wpn["__index"]["get_chaff_count"] = function: 0000023264DB7DF0
-- wpn["__index"]["emergency_jettison"] = function: 0000023264DB7970
-- wpn["__index"]["set_target_range"] = function: 0000023264DB7370
-- wpn["__index"]["set_target_span"] = function: 0000023264DB7220
-- wpn["__index"]["get_flare_count"] = function: 0000023264DB7EE0
-- wpn["__index"]["get_target_range"] = function: 0000023264DB7400
-- wpn["__index"]["get_target_span"] = function: 0000023264DB7340
-- wpn["__index"]["SetDamage"] = function: 0000023264DB6CE0
-- wpn["__index"]["drop_chaff"] = function: 0000023264DB7AF0
-- wpn["__index"]["select_station"] = function: 0000023264DB7250
-- wpn["__index"]["listen_command"] = function: 0000023264DB6C20
-- wpn["__index"]["emergency_jettison_rack"] = function: 0000023264DB78E0

-- wpn0 = {}
-- wpn0["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"
-- wpn0["container"] = false
-- wpn0["count"] = 1
-- wpn0["weapon"] = {}
-- wpn0["weapon"]["level3"] = 7
-- wpn0["weapon"]["level1"] = 4
-- wpn0["weapon"]["level4"] = 22
-- wpn0["weapon"]["level2"] = 4
-- wpn1 = {}
-- wpn1["CLSID"] = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}"
-- wpn1["container"] = false
-- wpn1["count"] = 1
-- wpn1["weapon"] = {}
-- wpn1["weapon"]["level3"] = 36
-- wpn1["weapon"]["level1"] = 4
-- wpn1["weapon"]["level4"] = 38
-- wpn1["weapon"]["level2"] = 5
-- wpn2 = {}
-- wpn2["CLSID"] = "{A-29B TANK}"
-- wpn2["container"] = false
-- wpn2["count"] = 1
-- wpn2["weapon"] = {}
-- wpn2["weapon"]["level3"] = 43
-- wpn2["weapon"]["level1"] = 1
-- wpn2["weapon"]["level4"] = 680
-- wpn2["weapon"]["level2"] = 3
-- wpn3 = {}
-- wpn3["CLSID"] = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}"
-- wpn3["container"] = false
-- wpn3["count"] = 1
-- wpn3["weapon"] = {}
-- wpn3["weapon"]["level3"] = 36
-- wpn3["weapon"]["level1"] = 4
-- wpn3["weapon"]["level4"] = 38
-- wpn3["weapon"]["level2"] = 5
-- wpn4 = {}
-- wpn4["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"
-- wpn4["container"] = false
-- wpn4["count"] = 1
-- wpn4["weapon"] = {}
-- wpn4["weapon"]["level3"] = 7
-- wpn4["weapon"]["level1"] = 4
-- wpn4["weapon"]["level4"] = 22
-- wpn4["weapon"]["level2"] = 4
-- wpn5 = {}
-- wpn5["CLSID"] = "{SMOKE-WHITE-A29B}"
-- wpn5["container"] = false
-- wpn5["count"] = 1
-- wpn5["weapon"] = {}
-- wpn5["weapon"]["level3"] = 50
-- wpn5["weapon"]["level1"] = 4
-- wpn5["weapon"]["level4"] = 681
-- wpn5["weapon"]["level2"] = 15

