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
    elseif command==device_commands.ExtLightTaxi then
        taxilight = value
    elseif command==device_commands.ExtLightLng then
        landlight = value
    end
end

local ExtLight_LeftNav_arg = 190
local ExtLight_RightNav_arg = 191
local ExtLight_Strobe_arg = 192
local ExtLight_TopCollision_arg = 198
local ExtLight_BottomCollision_arg = 199
local ExtLight_TopCollisionBrightness_arg = 200
local ExtLight_BottomCollisionBrightness_arg = 202
local ExtLight_TopCollisionRotation_arg = 201
local ExtLight_BottomCollisionRotation_arg = 203
local ExtLight_Taxi_arg = 208


local flashcounter = 0.5
local flashperminute = 60
local anticoll_inc = 1

-- returns linear movement from 0.0 to 1.0 at 85 cycles per minute
function update_anticoll_value()
    -- if anticoll_inc == 1 then
    --     flashcounter = flashcounter + (update_time_step*(flashperminute/60) * 0.5)
    -- else
    --     flashcounter = flashcounter - (update_time_step*(flashperminute/60) * 0.5)
    -- end

    -- if flashcounter > 1 or flashcounter < 0.075 then
    --     anticoll_inc = 1 - anticoll_inc
    -- end

    -- -- set flashing duty cycle here
    -- local a,b = math.modf(flashcounter) -- extract the decimal part
    -- return b

    local increase = update_time_step * (flashperminute/60)
    
    local y = flashcounter % 1
    flashcounter = flashcounter + increase
    return y

end


local flashcounter_ext = 0
local flashperminute_ext = 80

function update_flashing_ext()
    -- exterior lights flash 80 flashes/minute, on for 0.54 seconds and off for 0.21 seconds.
    flashcounter_ext = flashcounter_ext + (update_time_step*(flashperminute_ext/60))
    if flashcounter_ext > flashperminute_ext then
        flashcounter_ext = 0
    end

    -- set flashing duty cycle here
    local a,b = math.modf(flashcounter_ext) -- extract the decimal part
    if b < (0.54/(0.54+0.21)) then
        return 1
    else
        return 0
    end
end

local extlight_flashsteady=0
function update()
    local anticoll = update_anticoll_value()
    local flashon_ext = update_flashing_ext()
    local gear = get_aircraft_draw_argument_value(3)    -- right main gear extension

    if get_elec_main_bar_ok() then
        if extlight_flashsteady == 1 then
            -- in "FLASH" mode, modulate output with flashon value
            set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, navlight*flashon_ext)
            set_aircraft_draw_argument_value(ExtLight_RightNav_arg, navlight*flashon_ext)
            set_aircraft_draw_argument_value(ExtLight_Strobe_arg, strobelight*flashon_ext)
        else
            -- in "STEADY" mode, just draw them
            set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, navlight)
            set_aircraft_draw_argument_value(ExtLight_RightNav_arg, navlight)
            set_aircraft_draw_argument_value(ExtLight_Strobe_arg, strobelight*flashon_ext)
        end

        set_aircraft_draw_argument_value(ExtLight_Taxi_arg, (gear > 0) and (taxilight == 1 or (taxilight == 0 and sensor_data:getWOW_LeftMainLandingGear() >0)) and 1 or 0)

        if beaconlight == 1 then
            set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, beaconlight)
            set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, beaconlight)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, beaconlight)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, beaconlight)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionRotation_arg, anticoll)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionRotation_arg, anticoll)
        else
            set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, 0)
            set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, 0)

            set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, 0)
            set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, 0)
        end
        set_aircraft_draw_argument_value(209, searchlight) -- search light
        set_aircraft_draw_argument_value(193, landlight) -- landing light

        set_aircraft_draw_argument_value(83, formationlight) -- formation light

    else
        set_aircraft_draw_argument_value(ExtLight_LeftNav_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_RightNav_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_Strobe_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_Taxi_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_TopCollision_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_BottomCollision_arg, 0)

        set_aircraft_draw_argument_value(ExtLight_TopCollisionBrightness_arg, 0)
        set_aircraft_draw_argument_value(ExtLight_BottomCollisionBrightness_arg, 0)

        set_aircraft_draw_argument_value(209, 0) -- search light
        set_aircraft_draw_argument_value(193, 0) -- landing light

        set_aircraft_draw_argument_value(83, 0) -- formation light

    end

end


startup_print("extlights: load end")
need_to_be_closed = false -- close lua state after initialization


