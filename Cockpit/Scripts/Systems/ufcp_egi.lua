dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

-- Methods

function update_egi()
    local text = ""
    text = text .. "EGI\n"
    UFCP_TEXT:set(text)
end

function SetCommandEgi(command,value)

end