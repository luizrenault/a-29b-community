dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
local dev 	    = GetSelf()

local update_time_step = 1 --update will be called once per second

need_to_be_closed = false -- close lua state after initialization

