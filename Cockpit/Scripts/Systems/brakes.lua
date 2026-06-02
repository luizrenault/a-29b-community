dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

local PANEL_ALARM_TEST = get_param_handle("PANEL_ALARM_TEST")

local dev = GetSelf()

local update_time_step = 0.2
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local pbrake_light = get_param_handle("PBRAKE_LIGHT")
local pbrake_on = 0

function update()
        if pbrake_on == 1 or PANEL_ALARM_TEST:get() == 1 then 
            pbrake_light:set(1)
        else
            pbrake_light:set(0)
        end
        if not get_elec_main_bar_ok() then pbrake_light:set(0) end
end

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.EmerParkBrake, -1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.EmerParkBrake, 1, true)
    end
end

dev:listen_command(device_commands.EmerParkBrake)

function SetCommand(command,value)
    if command==device_commands.EmerParkBrake then
        if value == -1 then
            dispatch_action(0,iCommandPlaneWheelParkingBrake, 0)
            pbrake_on = 0
        else 
            dispatch_action(0,iCommandPlaneWheelParkingBrake, 1)
            pbrake_on = 1
        end
    end
end

need_to_be_closed = false


