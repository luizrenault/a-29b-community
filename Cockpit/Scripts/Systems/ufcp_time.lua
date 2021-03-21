dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

-- Constants

UFCP_TIME_TYPE_IDS = {
    LC = 0,
    RT = 1,
    SW = 2.
}
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.LC] = "LC"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.RT] = "RT"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.SW] = "SW"

-- Methods

function update_time()
    local text = ""
    text = text .. "TIME\n"
    UFCP_TEXT:set(text)
end

function SetCommandTime(command,value)

end