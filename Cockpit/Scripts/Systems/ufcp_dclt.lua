dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

HUD_DCLT = get_param_handle("HUD_DCLT")

-- Variables
ufcp_dclt = false;

-- Methods

function update_dclt()
    local text = ""
    text = text .. "DCLT\n\n"
    text = text .. "*ATT/FPM*"
    text = text .. "\n\n"
    if not ufcp_dclt then text = replace_pos(text, 7); text = replace_pos(text, 15) end

    if ufcp_dclt then
        HUD_DCLT:set(1)
    else
        HUD_DCLT:set(0)
    end

    UFCP_TEXT:set(text)
end

function SetCommandDclt(command,value)
    if command == device_commands.UFCP_0 and value == 1 then
        ufcp_dclt = not ufcp_dclt
    end
end