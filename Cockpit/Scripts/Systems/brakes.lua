dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("brakes: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("brakes: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.EmerParkBrake, -1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.EmerParkBrake, 1, true)
    end
    startup_print("brakes: postinit end")
end

local iCommandPlaneWheelBrakeOn = 74
local iCommandPlaneWheelBrakeOff = 75

dev:listen_command(device_commands.EmerParkBrake)
dev:listen_command(iCommandPlaneWheelBrakeOn)
dev:listen_command(iCommandPlaneWheelBrakeOff)

local pbrake_light = get_param_handle("PBRAKE_LIGHT")

function SetCommand(command,value)
    debug_message_to_user("brakes: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EmerParkBrake then
        if value ==-1 then
            dispatch_action(nil,iCommandPlaneWheelBrakeOff)
            pbrake_light:set(0)
        else 
            dispatch_action(nil,iCommandPlaneWheelBrakeOn)
            pbrake_light:set(1)
        end

    elseif command == iCommandPlaneWheelBrakeOff then
        dev:performClickableAction(device_commands.EmerParkBrake, -1, true)
    elseif command == iCommandPlaneWheelBrakeOn then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
        -- print_message_to_user("LG=" ..tostring(sensor_data:getWOW_LeftMainLandingGear()))

        -- local lat, lon, alt, nalt = sensor_data.getSelfCoordinates()
        -- print_message_to_user("SelfCoord: " ..tostring(lat).. " ".. tostring(lon).." "..tostring(alt).." "..tostring(nalt))

        -- speed, speeda, speedb = sensor_data.getSelfAirspeed()
        -- print_message_to_user("SelfAirspd: " ..tostring(speed) .. "  "..tostring(speeda) .." "..tostring(speedb))

        -- speedd = math.sqrt(speed*speed + speeda*speeda + speedb*speedb)

        -- local speed, speeda, speedb, speedc = sensor_data:getSelfVelocity()
        -- print_message_to_user("SelfVel: " ..tostring(speed) .. ","..tostring(speeda) .." "..tostring(speedb).." ".. tostring(speedc))
        
        -- speeda = math.sqrt(speed*speed + speeda*speeda + speedb*speedb)
        -- speed = sensor_data.getTrueAirSpeed()
        -- speedb = sensor_data.getIndicatedAirSpeed()
        -- print_message_to_user("TruefAirspd: " ..tostring(speed*1.94384) .. "  "..tostring(speedd*1.94384).. "  "..tostring(speeda*1.94384) .. "  ".. speedb*1.94384)

        -- speed = sensor_data.getVerticalVelocity()
        -- print_message_to_user("VertVel: " ..tostring(speed)  )

    end

end


startup_print("brakes: load end")
need_to_be_closed = false -- close lua state after initialization


