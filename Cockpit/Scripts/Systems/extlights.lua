dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

startup_print("extlights: load")

local dev = GetSelf()

local update_time_step = 1/30 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


function post_initialize()
    startup_print("extlights: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
        dev:performClickableAction(device_commands.ExtLightSearch, 0, true)
        dev:performClickableAction(device_commands.ExtLightBeacon, 0, true)
        dev:performClickableAction(device_commands.ExtLightStrobe, 1, true)
        dev:performClickableAction(device_commands.ExtLightInfrared, 0, true)
        dev:performClickableAction(device_commands.ExtLightNormal, -1, true)
        dev:performClickableAction(device_commands.ExtLightNav, 1, true)
        dev:performClickableAction(device_commands.ExtLightTaxi, 0, true)
        dev:performClickableAction(device_commands.ExtLightLng, 0, true)
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.ExtLightSearch, 0, true)
        dev:performClickableAction(device_commands.ExtLightBeacon, 0, true)
        dev:performClickableAction(device_commands.ExtLightStrobe, 1, true)
        dev:performClickableAction(device_commands.ExtLightInfrared, 0, true)
        dev:performClickableAction(device_commands.ExtLightNormal, -1, true)
        dev:performClickableAction(device_commands.ExtLightNav, 1, true)
        dev:performClickableAction(device_commands.ExtLightTaxi, 0, true)
        dev:performClickableAction(device_commands.ExtLightLng, 0, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.ExtLightSearch, 0, true)
        dev:performClickableAction(device_commands.ExtLightBeacon, 0, true)
        dev:performClickableAction(device_commands.ExtLightStrobe, 0, true)
        dev:performClickableAction(device_commands.ExtLightInfrared, 0, true)
        dev:performClickableAction(device_commands.ExtLightNormal, -1, true)
        dev:performClickableAction(device_commands.ExtLightNav, 0, true)
        dev:performClickableAction(device_commands.ExtLightTaxi, 0, true)
        dev:performClickableAction(device_commands.ExtLightLng, 0, true)
    end
    startup_print("extlights: postinit end")
end

dev:listen_command(device_commands.ExtLightSearch)
dev:listen_command(device_commands.ExtLightBeacon)
dev:listen_command(device_commands.ExtLightStrobe)
dev:listen_command(device_commands.ExtLightInfrared)
dev:listen_command(device_commands.ExtLightNormal)
dev:listen_command(device_commands.ExtLightNav)
dev:listen_command(device_commands.ExtLightTaxi)
dev:listen_command(device_commands.ExtLightLng)


local searchlight = 0
local beaconlight = 0 
local strobelight = 0 
local irlight = 0 
local formationlight = 0
local navlight = 0
local taxilight = 0
local landlight = 0


function SetCommand(command,value)
    debug_message_to_user("extlights: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.ExtLightSearch then
        searchlight = value
    elseif command == device_commands.ExtLightBeacon then
        beaconlight = value
    elseif command==device_commands.ExtLightStrobe then
        strobelight = value
    elseif command==device_commands.ExtLightInfrared then
        irlight = value
    elseif command == device_commands.ExtLightNormal then
        if value == 1 then 
            formationlight = 1
        elseif value == 0 then 
            formationlight = 0.5
        else 
            formationlight = 0
        end
    elseif command==device_commands.ExtLightNav then
        navlight = value
    end
end



function update()
    if get_elec_main_bar_ok() then 
        set_aircraft_draw_argument_value(802, beaconlight) -- beacon light
        set_aircraft_draw_argument_value(83, formationlight) -- formation light
        set_aircraft_draw_argument_value(49, navlight) -- nav light
        if searchlight==1 or landlight == 1 or taxilight == 1 or (taxilight == 0 and sensor_data:getWOW_LeftMainLandingGear() >0) then
            set_aircraft_draw_argument_value(51, 1) -- taxi light
        end
    else 
        set_aircraft_draw_argument_value(802, 0) -- beacon light
        set_aircraft_draw_argument_value(83, 0) -- formation light
        set_aircraft_draw_argument_value(49, 0) -- nav light
        set_aircraft_draw_argument_value(51, 0) -- taxi light
    end        
end


startup_print("extlights: load end")
need_to_be_closed = false -- close lua state after initialization


