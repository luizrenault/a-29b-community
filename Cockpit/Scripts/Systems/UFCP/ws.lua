 -- TODO update AA DGFT piper size based on this.
 local UFCP_WS = get_param_handle("UFCP_WS")

-- Inits
ufcp_ws = 11.1

UFCP_WS:set(ufcp_ws)

-- Methods

local function ufcp_ws_validate(text, save)
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 1 and number <= 99 then
            ufcp_ws = text
            UFCP_WS:set(ufcp_ws)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [0] = {4, ufcp_ws_validate},
}

local sel = 0
local max_sel = 1
function update_ws()
    local text = ""
    text = text .. "WINGSPAN\n\n"

    -- Wingspan
    text = text .. " *"
    if ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_ws) end
    text = text .. "*M\n\n"

    if ufcp_edit_pos > 0 then
        text = replace_pos(text, 12)
        text = replace_pos(text, 17)
    end
    
    UFCP_TEXT:set(text)
end

function SetCommandWs(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_continue_edit("1", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_continue_edit("2", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_continue_edit("3", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_continue_edit("4", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_continue_edit("5", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_continue_edit("6", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_continue_edit("7", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_continue_edit("8", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_continue_edit("9", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_continue_edit("0", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_continue_edit("", FIELD_INFO[sel], true)
    end
end