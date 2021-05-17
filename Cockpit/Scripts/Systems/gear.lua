dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("gear: load")

local PANEL_ALARM_TEST = get_param_handle("PANEL_ALARM_TEST")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("gear: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.LndGear, 1, true)
        dev:performClickableAction(device_commands.LndGearEmer, 0, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.LndGear, 0, true)
        dev:performClickableAction(device_commands.LndGearEmer, 0, true)
    end
    startup_print("gear: postinit end")
end

dev:listen_command(Keys.PlaneGear)
dev:listen_command(Keys.PlaneGearUp)
dev:listen_command(Keys.PlaneGearDown)

dev:listen_command(device_commands.LndGear)
dev:listen_command(device_commands.LndGearBeep)
dev:listen_command(device_commands.LndGearOvr)
dev:listen_command(device_commands.LndGearEmer)

function SetCommand(command,value)
    debug_message_to_user("gear: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.LndGear then
        if value == 1 then
            dev:performClickableAction(Keys.PlaneGearDown, 0, true)
        else 
            dev:performClickableAction(Keys.PlaneGearUp, 0, true)
        end
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("gear: load end")
need_to_be_closed = false -- close lua state after initialization


