dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step)


function update()
    -- print_message_to_user("LR::avSimplestFLIR")
end

function post_initialize()
    print_message_to_user("LR::avSimplestMap")
end


function SetCommand(command, value)
    -- print_message_to_user("flir: command "..tostring(command).." = "..tostring(value))
end

need_to_be_closed = false
