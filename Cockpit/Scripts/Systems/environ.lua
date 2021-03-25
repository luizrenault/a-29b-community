dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("environ: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("environ: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
        dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
        dev:performClickableAction(device_commands.EnvAC, 1, true)
        dev:performClickableAction(device_commands.EnvECS, 1, true)
        dev:performClickableAction(device_commands.EnvRecFan, 1, true)
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
        dev:performClickableAction(device_commands.EnvAC, 1, true)
        dev:performClickableAction(device_commands.EnvECS, 1, true)
        dev:performClickableAction(device_commands.EnvRecFan, 1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
        dev:performClickableAction(device_commands.EnvAC, 0, true)
        dev:performClickableAction(device_commands.EnvECS, 0, true)
        dev:performClickableAction(device_commands.EnvRecFan, 0, true)
    end
    startup_print("environ: postinit end")
end

dev:listen_command(device_commands.IcePropeller)
dev:listen_command(device_commands.IceWindshield)
dev:listen_command(device_commands.IcePitotPri)
dev:listen_command(device_commands.IcePitotSec)

function SetCommand(command,value)
    debug_message_to_user("environ: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("environ: load end")
need_to_be_closed = false -- close lua state after initialization


