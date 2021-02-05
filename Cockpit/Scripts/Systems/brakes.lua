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

function SetCommand(command,value)
    debug_message_to_user("brakes: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EmerParkBrake then
        if value ==-1 then
            dispatch_action(nil,iCommandPlaneWheelBrakeOff)
        else 
            dispatch_action(nil,iCommandPlaneWheelBrakeOn)
        end
    elseif command == iCommandPlaneWheelBrakeOff then
        dev:performClickableAction(device_commands.EmerParkBrake, -1, true)
    elseif command == iCommandPlaneWheelBrakeOn then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
        -- print_message_to_user("LG=" ..tostring(sensor_data:getWOW_LeftMainLandingGear()))
    end
end


startup_print("brakes: load end")
need_to_be_closed = false -- close lua state after initialization


