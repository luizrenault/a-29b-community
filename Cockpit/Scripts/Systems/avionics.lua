dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("avionics: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


function update()
    -- IAS
    local ias = sensor_data.getIndicatedAirSpeed() * 1.94384
    local iasx, iasy, iasz = sensor_data.getSelfAirspeed()
    if ias == 0 then ias = math.sqrt(iasx * iasx + iasy * iasy + iasz * iasz )  * 1.94384 end
    if ias < 30 then
        ias = 0
    end

    -- ALT
    local altitude = round_to(sensor_data.getBarometricAltitude()*3.2808399,10)

    -- RALT
    local radar_alt = sensor_data.getRadarAltitude() * 3.2808399
    if radar_alt > 0 and radar_alt < 5000 then radar_alt = round_to(radar_alt, 10) else radar_alt = -1 end

    -- VV
    local vv = sensor_data.getVerticalVelocity() * 3.2808399 * 60
    vv = round_to(vv, 10)
    
    -- HDG
    local hdg = math.deg(-sensor_data.getHeading())
    if hdg < 0 then hdg = 360 + hdg end
    hdg = hdg % 360

    -- Turn Rate (deg/min)
    local turn_rate = math.deg(sensor_data.getRateOfYaw())*60


    AVIONICS_IAS:set(ias)
    AVIONICS_ALT:set(altitude)
    AVIONICS_VV:set(vv)
    AVIONICS_HDG:set(hdg)
    AVIONICS_RALT:set(radar_alt)
    AVIONICS_TURN_RATE:set(turn_rate)


end

function post_initialize()
    startup_print("avionics: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
        -- dev:performClickableAction(device_commands.EnvRecFan, 0, true)
    end
    startup_print("avionics: postinit end")
end

-- dev:listen_command(device_commands.IcePropeller)

function SetCommand(command,value)
    debug_message_to_user("avionics: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("avionics: load end")
need_to_be_closed = false -- close lua state after initialization


