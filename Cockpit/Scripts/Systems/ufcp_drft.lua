HUD_DRIFT_CO = get_param_handle("HUD_DRIFT_CO")

-- Variables
ufcp_drift_co = false;

-- Methods

function update_drft()
    local text = ""
    text = text .. "DRIFT\n\n"
    if not ufcp_drift_co then text = text .. "*NORM     *" else text = text .. "*DRIFT C/O*" end
    text = text .. "\n\n"
    text = replace_pos(text, 8)
    text = replace_pos(text, 18)

    UFCP_TEXT:set(text)
end

function SetCommandDrft(command,value)
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_drift_co = not ufcp_drift_co
    end
end