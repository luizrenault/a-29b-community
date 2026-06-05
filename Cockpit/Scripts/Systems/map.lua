dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

local dev = GetSelf()

local update_time_step = 0.02
-- make_default_activity(update_time_step)
need_to_be_closed = false

local sensor_data = get_base_data()

function update()
end

function post_initialize()
end

function SetCommand(command,value)
end