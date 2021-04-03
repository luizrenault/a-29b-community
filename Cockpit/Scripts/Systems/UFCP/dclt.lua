HUD_DCLT = get_param_handle("HUD_DCLT")

-- Variables
ufcp_dclt = false;

-- Methods

function update_dclt()
    local text = ""
    text = text .. "DCLT\n\n"
    if not ufcp_dclt then text = text .. "*ATT/FPM*" else text = text .. "*DCLT   *" end
    
    text = text .. "\n\n"
    text = replace_pos(text, 7)
    text = replace_pos(text, 15)

    if ufcp_dclt then
        HUD_DCLT:set(1)
    else
        HUD_DCLT:set(0)
    end

    UFCP_TEXT:set(text)
end

function SetCommandDclt(command,value)
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_dclt = not ufcp_dclt
    end
end