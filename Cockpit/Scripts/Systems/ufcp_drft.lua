dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

HUD_DRIFT_CO = get_param_handle("HUD_DRIFT_CO")

-- Variables
ufcp_drift_co = false;

-- Methods

function update_drft()
    local text = ""
    text = text .. "DRIFT\n\n"
    text = text .. "*DRIFT C/O*"
    text = text .. "\n\n"
    if ufcp_drift_co then text = replace_pos(text, 8); text = replace_pos(text, 18) end

    UFCP_TEXT:set(text)
end

function SetCommandDrft(command,value)
    if command == device_commands.UFCP_0 and value == 1 then
        ufcp_drift_co = not ufcp_drift_co
    end
end