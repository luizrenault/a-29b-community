HUD_VAH = get_param_handle("HUD_VAH")
HUD_VAH:set(0)

-- Constants
-- VV/VAH

-- Variables

-- Methods
local sel = UFCP_VVVAH_MODE_IDS.OFF
function update_vvvah()
    local text = ""
    text = text .. "VV/VAH\n\n"
    if sel == UFCP_VVVAH_MODE_IDS.VAH    then  text = text .. "*VAH*       \n" else text = text .. " VAH        \n" end
    if sel == UFCP_VVVAH_MODE_IDS.OFF    then  text = text .. "*OFF*       \n" else text = text .. " OFF        \n" end
    if sel == UFCP_VVVAH_MODE_IDS.VV_VAH then  text = text .. "*VV/VAH*    "   else text = text .. " VV/VAH     " end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VAH then text = replace_pos(text, 9); text = replace_pos(text, 13); end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.OFF then text = replace_pos(text, 22); text = replace_pos(text, 26); end
    if ufcp_vvvah_mode == UFCP_VVVAH_MODE_IDS.VV_VAH then text = replace_pos(text, 35); text = replace_pos(text, 42); end

    UFCP_TEXT:set(text)
end

function SetCommandVVVAH(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        sel = (sel + 1) % (UFCP_VVVAH_MODE_IDS.VV_VAH + 1)
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        sel = (sel - 1) % (UFCP_VVVAH_MODE_IDS.VV_VAH + 1)
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_vvvah_mode = sel
    end
end