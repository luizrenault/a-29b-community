dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")

startup_print("radio: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
-- make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("radio: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
        -- dev:performClickableAction(device_commands.EnvRecFan, 0, true)
    end
    -- dump1("make_setup_for_communicator", dev:make_setup_for_communicator())
    -- dump1("is_communicator_available", dev:is_communicator_available())
    -- dump1("easy_comm_override", dev:easy_comm_override())
    -- dump1("get_noise_level", dev:get_noise_level())
    -- dump1("get_signal_level", dev:get_signal_level())

    startup_print("radio: postinit end")
end

-- dev:listen_command(device_commands.IcePitotSec)

function SetCommand(command,value)
    print_message_to_user("radio: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("radio: load end")
need_to_be_closed = false -- close lua state after initialization


